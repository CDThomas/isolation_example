defmodule IsolationExample.LostUpdate.Transaction do
  alias IsolationExample.PromoCode
  alias IsolationExample.Repo

  import Ecto.Query, only: [from: 2]

  def transaction(f) do
    Repo.transaction(fn ->
      Repo.query!("set transaction isolation level repeatable read;")
      f.()
    end)
  end

  def run(parent) do
    receive do
      :select ->
        :ok
    end

    select()
    send(parent, {self(), :done})

    receive do
      :update ->
        :ok
    end

    update()
    send(parent, {self(), :done})

    receive do
      :commit ->
        :ok
    end

    IO.inspect(self(), label: "Commit:\n")
    send(parent, {self(), :done})
  end

  defp select do
    result = Repo.one(from pc in PromoCode, select: pc.code, where: pc.code == "moo")

    IO.inspect({self(), result}, label: "Select:\n")
  end

  defp update do
    query =
      from pc in PromoCode,
        select: pc.is_used,
        update: [set: [is_used: true]],
        where: pc.code == "moo"

    result = Repo.update_all(query, [])

    IO.inspect({self(), result}, label: "Update:\n")
  end
end
