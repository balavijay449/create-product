defmodule EbayCrud.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EbayCrud.Inventory` context.
  """

  @doc """
  Generate a inventory_item.
  """
  def inventory_item_fixture(attrs \\ %{}) do
    {:ok, inventory_item} =
      attrs
      |> Enum.into(%{
        data: "some data",
        sku: "some sku"
      })
      |> EbayCrud.Inventory.create_inventory_item()

    inventory_item
  end

  @doc """
  Generate a offer.
  """
  def offer_fixture(attrs \\ %{}) do
    {:ok, offer} =
      attrs
      |> Enum.into(%{
        offer_id: "some offer_id",
        sku: "some sku",
        values: %{}
      })
      |> EbayCrud.Inventory.create_offer()

    offer
  end
end
