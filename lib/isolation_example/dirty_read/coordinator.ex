defmodule IsolationExample.DirtyRead.Coordinator do
  alias IsolationExample.DirtyRead.SelectTransaction
  alias IsolationExample.DirtyRead.UpdateTransaction

  def race do
    select_pid = start_transaction(SelectTransaction)
    update_pid = start_transaction(UpdateTransaction)

    :ok = sync(select_pid, :select_one)
    :ok = sync(update_pid, :update_one)
    :ok = sync(update_pid, :update_two)
    :ok = sync(select_pid, :select_two)

    :ok = sync(select_pid, :commit)
    :ok = sync(update_pid, :commit)
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
