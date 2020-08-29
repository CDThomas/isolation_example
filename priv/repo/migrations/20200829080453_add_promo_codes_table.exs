defmodule IsolationExample.Repo.Migrations.AddPromoCodesTable do
  use Ecto.Migration

  def change do
    create table(:promo_codes) do
      add :code, :string
      add :is_used, :boolean
    end
  end
end
