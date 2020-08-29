defmodule IsolationExample.LostUpdate.Coordinator do
  alias IsolationExample.LostUpdate.Transaction
  alias IsolationExample.Repo
  alias IsolationExample.RepoTwo

  def race do
    pid_one = start_transaction(Transaction, Repo) |> IO.inspect(label: "pid_one:\n")
    pid_two = start_transaction(Transaction, RepoTwo) |> IO.inspect(label: "pid_two:\n")
    Process.get_keys() |> IO.inspect(label: "Keys:\n")

    :ok = sync(pid_one, :select)
    :ok = sync(pid_two, :select)

    :ok = sync(pid_one, :update)

    # Blocking here causes a timeout because of the lock from the first update
    :ok = sync(pid_two, :update)

    :ok = sync(pid_one, :commit)
    :ok = sync(pid_two, :commit)
  end

  def sync(pid, msg) do
    send(pid, msg)

    receive do
      {^pid, :done} ->
        :ok
    end
  end

  def start_transaction(mod, repo) do
    pid = self()

    spawn(fn ->
      mod.transaction(fn -> mod.run(pid, repo) end, repo)
    end)
  end
end
