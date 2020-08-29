defmodule IsolationExample.DirtyRead.Coordinator do
  def race(mod) do
    select_transaction = start_select_transaction(mod, :select_transaction)
    update_transaction = start_update_transaction(mod, :update_transaction)

    :ok = sync(select_transaction, :select_one)
    :ok = sync(update_transaction, :update_one)

    :ok = sync(update_transaction, :update_two)
    # We don't want to block here in case the transaction crashes
    send(select_transaction, :select_two)

    :ok = sync(select_transaction, :commit)
    send(update_transaction, :commit)
  end

  def sync(pid, msg) do
    send(pid, msg)

    receive do
      {^pid, :done} ->
        :ok
    end
  end

  def start_select_transaction(mod, name) do
    pid = self()

    spawn(fn ->
      mod.transaction(fn -> mod.run_selects(pid, name) end)
    end)
  end

  def start_update_transaction(mod, name) do
    pid = self()

    spawn(fn ->
      mod.transaction(fn -> mod.run_updates(pid, name) end)
    end)
  end
end
