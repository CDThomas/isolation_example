defmodule IsolationExample.DirtyRead.Runner do
  alias IsolationExample.Account
  alias IsolationExample.Repo

  import Ecto.Query, only: [from: 2]

  def transaction(f) do
    Repo.transaction(f)
  end

  def run_selects(parent, _name) do
    receive do
      :select_one ->
        :ok
    end

    select_one()
    send(parent, {self(), :done})

    receive do
      :select_two ->
        :ok
    end

    select_two()
    send(parent, {self(), :done})

    receive do
      :commit ->
        :ok
    end

    send(parent, {self(), :done})
  end

  def run_updates(parent, _name) do
    receive do
      :update_one ->
        :ok
    end

    update_one()
    send(parent, {self(), :done})

    receive do
      :update_two ->
        :ok
    end

    update_two()
    send(parent, {self(), :done})

    receive do
      :commit ->
        :ok
    end

    send(parent, {self(), :done})
  end

  defp select_one do
    Repo.one(from a in Account, select: a.balance, where: a.id == 1)
    |> IO.inspect(label: "SELECT_ONE:\n")
  end

  defp select_two do
    Repo.one(from a in Account, select: a.balance, where: a.id == 2)
    |> IO.inspect(label: "SELECT_TWO:\n")
  end

  defp update_one do
    query =
      from a in Account,
        update: [set: [balance: a.balance + 100]],
        where: a.id == 1

    Repo.update_all(query, [])
    |> IO.inspect(label: "UPDATE_ONE:\n")
  end

  defp update_two do
    query =
      from a in Account,
        update: [set: [balance: a.balance - 100]],
        where: a.id == 2

    Repo.update_all(query, [])
    |> IO.inspect(label: "UPDATE_TWO:\n")
  end
end
