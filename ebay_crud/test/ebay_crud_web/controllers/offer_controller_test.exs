defmodule EbayCrudWeb.OfferControllerTest do
  use EbayCrudWeb.ConnCase

  import EbayCrud.InventoryFixtures

  alias EbayCrud.Inventory.Offer

  @create_attrs %{
    offer_id: "some offer_id",
    sku: "some sku",
    values: %{}
  }
  @update_attrs %{
    offer_id: "some updated offer_id",
    sku: "some updated sku",
    values: %{}
  }
  @invalid_attrs %{offer_id: nil, sku: nil, values: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all offers", %{conn: conn} do
      conn = get(conn, Routes.offer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create offer" do
    test "renders offer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.offer_path(conn, :create), offer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.offer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "offer_id" => "some offer_id",
               "sku" => "some sku",
               "values" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.offer_path(conn, :create), offer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update offer" do
    setup [:create_offer]

    test "renders offer when data is valid", %{conn: conn, offer: %Offer{id: id} = offer} do
      conn = put(conn, Routes.offer_path(conn, :update, offer), offer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.offer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "offer_id" => "some updated offer_id",
               "sku" => "some updated sku",
               "values" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, offer: offer} do
      conn = put(conn, Routes.offer_path(conn, :update, offer), offer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete offer" do
    setup [:create_offer]

    test "deletes chosen offer", %{conn: conn, offer: offer} do
      conn = delete(conn, Routes.offer_path(conn, :delete, offer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.offer_path(conn, :show, offer))
      end
    end
  end

  defp create_offer(_) do
    offer = offer_fixture()
    %{offer: offer}
  end
end
