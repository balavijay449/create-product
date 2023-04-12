defmodule EbayCrudWeb.InventoryItemController do
  use EbayCrudWeb, :controller

  alias EbayCrud.Inventory
  alias EbayCrud.Inventory.InventoryItem

  action_fallback EbayCrudWeb.FallbackController

  def index(conn, _params) do
    inventory_items = Inventory.list_inventory_items()
    render(conn, "index.json", inventory_items: inventory_items)
  end

  def create(conn, %{"inventory_item" => inventory_item_params, "sku" => sku}) do
    with {:ok, %InventoryItem{} = inventory_item} <-
      Inventory.create_inventory_item(inventory_item_params, sku) do
      conn
      |> put_status(:created)
      |> render("show.json", inventory_item: inventory_item)
    else
      response ->
        render(conn, "error.json", inventory_item: response)
    end
  end

  def show(conn, %{"id" => sku}) do
    inventory_item = Inventory.get_inventory_item!(sku)
    render(conn, "show.json", inventory_item: inventory_item)
  end

  def update(conn, %{"id" => sku, "inventory_item" => attrs}) do
    inventory_item = Inventory.get_inventory_item!(sku)

    with {:ok, %InventoryItem{} = inventory_item} <- Inventory.update_inventory_item(inventory_item, attrs) do
      render(conn, "show.json", inventory_item: inventory_item)
    else
      response ->
        render(conn, "error.json", inventory_item: response)
    end
  end

  def delete(conn, %{"id" => sku}) do
    inventory_item = Inventory.get_inventory_item!(sku)

    with {:ok, %InventoryItem{}} <- Inventory.delete_inventory_item(inventory_item) do
      send_resp(conn, :no_content, "")
    else
      response ->
        render(conn, "error.json", inventory_item: response)
    end
  end
end
