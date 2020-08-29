defmodule IsolationExample.LostUpdate.Transaction do
  alias IsolationExample.PromoCode

  import Ecto.Query, only: [from: 2]

  def transaction(f, repo) do
    repo.transaction(fn ->
      Process.get_keys() |> IO.inspect(label: "Keys:\n")
      # repo.query!("set transaction isolation level repeatable read;")
      f.()
    end)
  end

  def run(parent, repo) do
    receive do
      :select ->
        :ok
    end

    select(repo)
    send(parent, {self(), :done})

    receive do
      :update ->
        :ok
    end

    update(repo)
    send(parent, {self(), :done})

    receive do
      :commit ->
        :ok
    end

    IO.inspect(self(), label: "Commit:\n")
    send(parent, {self(), :done})
  end

  defp select(repo) do
    Process.get_keys() |> IO.inspect(label: "Keys:\n")
    result = repo.one(from pc in PromoCode, select: pc.code, where: pc.code == "moo")

    IO.inspect({self(), result}, label: "Select:\n")
  end

  defp update(repo) do
    Process.get_keys() |> IO.inspect(label: "Keys:\n")

    query =
      from pc in PromoCode,
        select: pc.is_used,
        update: [set: [is_used: true]],
        where: pc.code == "moo"

    result = repo.update_all(query, [])

    IO.inspect({self(), result}, label: "Update:\n")
  end
end
