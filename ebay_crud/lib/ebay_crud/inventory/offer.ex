defmodule EbayCrud.Inventory.Offer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offers" do
    field :offer_id, :string
    field :sku, :string
    field :values, :map
    field :is_published, :boolean
    field :listing_id, :string

    timestamps()
  end

  @doc false
  def changeset(offer, attrs) do
    offer
    |> cast(attrs, [:sku, :values, :offer_id, :is_published, :listing_id])
    |> validate_required([:sku, :values, :offer_id])
  end
end
