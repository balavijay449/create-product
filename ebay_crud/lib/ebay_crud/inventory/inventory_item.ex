defmodule EbayCrud.Inventory.InventoryItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_items" do
    field :data, :string
    field :sku, :string
    field :values, :map

    timestamps()
  end

  @doc false
  def changeset(inventory_item, attrs) do
    inventory_item
    |> cast(attrs, [:data, :sku, :values])
    |> validate_required([:sku, :values])
    |> unique_constraint(:sku)
  end
end
