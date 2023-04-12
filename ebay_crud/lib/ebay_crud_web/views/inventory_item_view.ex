defmodule EbayCrudWeb.InventoryItemView do
  use EbayCrudWeb, :view
  alias EbayCrudWeb.InventoryItemView

  def render("index.json", %{inventory_items: inventory_items}) do
    %{data: render_many(inventory_items, InventoryItemView, "inventory_item.json")}
  end

  def render("show.json", %{inventory_item: inventory_item}) do
    %{data: render_one(inventory_item, InventoryItemView, "inventory_item.json")}
  end

  def render("inventory_item.json", %{inventory_item: inventory_item}) do
    %{
      id: inventory_item.id,
      sku: inventory_item.sku,
      values: inventory_item.values
    }
  end

  def render("success.json", %{inventory_item: status}) do
    %{data: %{status: status}}
  end

  def render("error.json", %{inventory_item: response}) do
    %{data: %{error: response}}
  end
end
