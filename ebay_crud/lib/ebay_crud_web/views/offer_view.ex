defmodule EbayCrudWeb.OfferView do
  use EbayCrudWeb, :view
  alias EbayCrudWeb.OfferView

  def render("index.json", %{offers: offers}) do
    %{data: render_many(offers, OfferView, "offer.json")}
  end

  def render("show.json", %{offer: offer}) do
    %{data: render_one(offer, OfferView, "offer.json")}
  end

  def render("offer.json", %{offer: offer}) do
    %{
      id: offer.id,
      sku: offer.sku,
      values: offer.values,
      offer_id: offer.offer_id,
      is_published: offer.is_published,
      listing_id: offer.listing_id
    }
  end

  def render("success.json", %{offer: offer}) do
    %{data: offer}
  end
end
