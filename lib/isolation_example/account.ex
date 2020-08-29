defmodule IsolationExample.Account do
  use Ecto.Schema

  schema "accounts" do
    field :balance, :integer
  end
end
