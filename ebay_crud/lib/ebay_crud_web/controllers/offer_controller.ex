defmodule EbayCrudWeb.OfferController do
  use EbayCrudWeb, :controller

  alias EbayCrud.Inventory
  alias EbayCrud.Inventory.Offer

  action_fallback EbayCrudWeb.FallbackController

  def index(conn, %{"sku" => sku}) do
    offer = Inventory.get_offer_by_sku!(sku)
    render(conn, "show.json", offer: offer)
  end

  def index(conn, _params) do
    offers = Inventory.list_offers()
    render(conn, "index.json", offers: offers)
  end

  def create(conn, %{"offer" => offer_params}) do
    with {:ok, %Offer{} = offer} <- Inventory.create_offer(offer_params) do
      conn
      |> put_status(:created)
      |> render("show.json", offer: offer)
    end
  end

  def show(conn, %{"id" => id}) do
    offer = Inventory.get_offer!(id)
    render(conn, "show.json", offer: offer)
  end

  def update(conn, %{"id" => id, "offer" => offer_params}) do
    offer = Inventory.get_offer!(id)

    with {:ok, %Offer{} = offer} <- Inventory.update_offer(offer, offer_params) do
      render(conn, "show.json", offer: offer)
    end
    # offer = Inventory.update_offer(offer, offer_params)
    # render(conn, "success.json", offer: offer)
  end

  # def delete(conn, %{"id" => id}) do
  #   offer = Inventory.get_offer!(id)

  #   with {:ok, %Offer{}} <- Inventory.delete_offer(offer) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

  def publish(conn, %{"id" => id}) do
    offer = Inventory.get_offer!(id)

    with {:ok, %Offer{} = offer} <- Inventory.publish_offer(offer) do
      render(conn, "show.json", offer: offer)
    end
  end
end
