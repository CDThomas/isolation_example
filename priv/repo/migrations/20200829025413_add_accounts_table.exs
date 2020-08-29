defmodule IsolationExample.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :integer
    end
  end
end
