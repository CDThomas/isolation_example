defmodule IsolationExample.LostUpdate.Coordinator do
  alias IsolationExample.LostUpdate.Transaction

  def race do
    pid_one = start_transaction(Transaction)
    pid_two = start_transaction(Transaction)

    :ok = sync(pid_one, :select)
    :ok = sync(pid_two, :select)

    :ok = sync(pid_one, :update)
    :ok = sync(pid_one, :commit)

    :ok = sync(pid_two, :update)
    :ok = sync(pid_two, :commit)
  end

  def sync(pid, msg) do
    send(pid, msg)

    receive do
      {^pid, :done} ->
        :ok
    end
  end

  def start_transaction(mod) do
    pid = self()

    spawn(fn ->
      mod.transaction(fn -> mod.run(pid) end)
    end)
  end
end
