defmodule IsolationExample.PromoCode do
  use Ecto.Schema

  schema "promo_codes" do
    field :code, :string
    field :is_used, :boolean
  end
end
