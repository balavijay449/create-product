defmodule EbayCrudWeb.InventoryItemControllerTest do
  use EbayCrudWeb.ConnCase

  import EbayCrud.InventoryFixtures

  alias EbayCrud.Inventory.InventoryItem

  @create_attrs %{
    data: "some data",
    sku: "some sku"
  }
  @update_attrs %{
    data: "some updated data",
    sku: "some updated sku"
  }
  @invalid_attrs %{data: nil, sku: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all inventory_items", %{conn: conn} do
      conn = get(conn, Routes.inventory_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create inventory_item" do
    test "renders inventory_item when data is valid", %{conn: conn} do
      conn = post(conn, Routes.inventory_item_path(conn, :create), inventory_item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.inventory_item_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "data" => "some data",
               "sku" => "some sku"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.inventory_item_path(conn, :create), inventory_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update inventory_item" do
    setup [:create_inventory_item]

    test "renders inventory_item when data is valid", %{conn: conn, inventory_item: %InventoryItem{id: id} = inventory_item} do
      conn = put(conn, Routes.inventory_item_path(conn, :update, inventory_item), inventory_item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.inventory_item_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "data" => "some updated data",
               "sku" => "some updated sku"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, inventory_item: inventory_item} do
      conn = put(conn, Routes.inventory_item_path(conn, :update, inventory_item), inventory_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete inventory_item" do
    setup [:create_inventory_item]

    test "deletes chosen inventory_item", %{conn: conn, inventory_item: inventory_item} do
      conn = delete(conn, Routes.inventory_item_path(conn, :delete, inventory_item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.inventory_item_path(conn, :show, inventory_item))
      end
    end
  end

  defp create_inventory_item(_) do
    inventory_item = inventory_item_fixture()
    %{inventory_item: inventory_item}
  end
end
