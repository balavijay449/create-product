defmodule EbayCrud.Inventory do
  @moduledoc """
  The Inventory context.
  """

  @api_endpoint_for_inventory_item "https://api.ebay.com/sell/inventory/v1/inventory_item"
  @api_endpoint_for_offer "https://api.ebay.com/sell/inventory/v1/offer"
  @token EbayCrud.token()
  @headers [
    {"Authorization", "Bearer #{@token}"},
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  import Ecto.Query, warn: false
  alias EbayCrud.Repo

  alias EbayCrud.Inventory.InventoryItem

  @doc """
  Returns the list of inventory_items.

  ## Examples

      iex> list_inventory_items()
      [%InventoryItem{}, ...]

  """
  def list_inventory_items() do
    Repo.all(InventoryItem)
  end

  @doc """
  Gets a single inventory_item.

  Raises `Ecto.NoResultsError` if the Inventory item does not exist.

  ## Examples

      iex> get_inventory_item!(123)
      %InventoryItem{}

      iex> get_inventory_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory_item!(sku), do: Repo.get_by!(InventoryItem, sku: sku)

  @doc """
  Creates a inventory_item.

  ## Examples

      iex> create_inventory_item(%{field: value})
      {:ok, %InventoryItem{}}

      iex> create_inventory_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory_item(attrs, sku) do
    with {:ok, _} <- check_sku_is_unique(sku),
      {:ok, _} <- create_or_update_ebay_inventory_item(attrs, sku) do
      params = Map.put(%{}, "values", attrs)
      params = Map.put(params, "sku", sku)
      %InventoryItem{}
      |> InventoryItem.changeset(params)
      |> Repo.insert()
    else
      {:error, response} -> response
    end
  end

  def create_or_update_ebay_inventory_item(attrs, sku) do
    json_body = Jason.encode!(attrs) |> String.replace(~r/\\/u, "")
    headers = @headers ++ [{"Content-Language", "en-GB"}]
    @api_endpoint_for_inventory_item <> "/#{sku}"
    |> HTTPoison.put(json_body, headers)
    |> parse()
  end

  def check_sku_is_unique(sku) do
    case InventoryItem |> where(sku: ^sku) |> Repo.one() do
      nil -> {:ok, "success"}
      _ ->
        {:error, "Sku already exists! If you try to update the data, please click the update button."}
    end
  end

  defp parse({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> Poison.decode()
  end

  defp parse({:ok, %HTTPoison.Response{status_code: 204}}) do
    {:ok, "Inventory Item Created/Updated Successfully!"}
  end

  defp parse({:ok, %HTTPoison.Response{body: body, status_code: _status_code}}) do
    {:error, body |> Poison.decode!()}
  end

  @doc """
  Updates a inventory_item.

  ## Examples

      iex> update_inventory_item(inventory_item, %{field: new_value})
      {:ok, %InventoryItem{}}

      iex> update_inventory_item(inventory_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory_item(%InventoryItem{} = inventory_item, attrs) do
    sku = inventory_item.sku
    with {:ok, _} <- create_or_update_ebay_inventory_item(attrs, sku) do
      params = Map.put(%{}, "values", attrs)
      params = Map.put(params, "sku", sku)
      inventory_item
      |> InventoryItem.changeset(params)
      |> Repo.update()
    else
      {:error, response} -> response
    end
  end

  @doc """
  Deletes a inventory_item.

  ## Examples

      iex> delete_inventory_item(inventory_item)
      {:ok, %InventoryItem{}}

      iex> delete_inventory_item(inventory_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory_item(%InventoryItem{} = inventory_item) do
    sku = inventory_item.sku
    with {:ok, _} <- delete_ebay_inventory_item(sku) do
      Repo.delete(inventory_item)
    else
      {:error, response} -> response
    end
  end

  def delete_ebay_inventory_item(sku) do
    @api_endpoint_for_inventory_item <> "/#{sku}"
    |> HTTPoison.delete(@headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        {:ok, "deteted"}
      {:ok, %HTTPoison.Response{body: body, status_code: _status_code}} ->
        {:error, body |> Poison.decode!()}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventory_item changes.

  ## Examples

      iex> change_inventory_item(inventory_item)
      %Ecto.Changeset{data: %InventoryItem{}}

  """
  def change_inventory_item(%InventoryItem{} = inventory_item, attrs \\ %{}) do
    InventoryItem.changeset(inventory_item, attrs)
  end

  alias EbayCrud.Inventory.Offer

  @doc """
  Returns the list of offers.

  ## Examples

      iex> list_offers()
      [%Offer{}, ...]

  """
  def list_offers do
    Repo.all(Offer)
  end

  @doc """
  Gets a single offer.

  Raises `Ecto.NoResultsError` if the Offer does not exist.

  ## Examples

      iex> get_offer!(123)
      %Offer{}

      iex> get_offer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_offer!(id), do: Repo.get_by!(Offer, offer_id: id)

  def get_offer_by_sku!(sku), do: Repo.get_by!(Offer, sku: sku)

  @doc """
  Creates a offer.

  ## Examples

      iex> create_offer(%{field: value})
      {:ok, %Offer{}}

      iex> create_offer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_offer(attrs \\ %{}) do
  #   %Offer{}
  #   |> Offer.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_offer(attrs) do
    with {:ok, offer_id} <- create_ebay_offer(attrs) do
      sku = attrs["sku"]
      offer_id = offer_id["offerId"]
      values = Map.delete(attrs, "sku")
      merged_map = %{"sku" => sku, "values" => values, "offer_id" => offer_id}
      %Offer{}
      |> Offer.changeset(merged_map)
      |> Repo.insert()
    else
      {:error, response} -> response
    end
  end

  def create_ebay_offer(attrs) do
    json_body = Jason.encode!(attrs) |> String.replace(~r/\\/u, "")
    headers = @headers ++ [{"Content-Language", "en-GB"}]
    @api_endpoint_for_offer
    |> HTTPoison.post(json_body, headers)
    |> case do
      {:ok, %HTTPoison.Response{body: body, status_code: 201}} ->
        body |> Poison.decode()
      others -> parse(others)
    end
  end

  @doc """
  Updates a offer.

  ## Examples

      iex> update_offer(offer, %{field: new_value})
      {:ok, %Offer{}}

      iex> update_offer(offer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_offer(%Offer{} = offer, attrs) do
    with {:ok, offer_id} <- update_ebay_offer(offer.offer_id, attrs) do
      attrs = %{"values" => attrs}
      offer
      |> Offer.changeset(attrs)
      |> Repo.update()
    else
      {:error, response} -> response
    end
  end

  def update_ebay_offer(offer_id, attrs) do
    json_body = Jason.encode!(attrs) |> String.replace(~r/\\/u, "")
    headers = @headers ++ [{"Content-Language", "en-GB"}]
    @api_endpoint_for_offer <> "/#{offer_id}"
    |> HTTPoison.put(json_body, headers)
    |> parse()
  end

  def publish_offer(%Offer{} = offer) do
    with {:ok, response} <- publish_offer_in_ebay(offer.offer_id) do
      listing_id = response["listingId"]
      merged_map = %{"is_published" => true, "listing_id" => listing_id}
      offer
      |> Offer.changeset(merged_map)
      |> Repo.update()
    end
  end

  defp publish_offer_in_ebay(id) do
    @api_endpoint_for_offer <> "/#{id}/publish"
    |> HTTPoison.post([], @headers)
    |> parse()
  end

  @doc """
  Deletes a offer.

  ## Examples

      iex> delete_offer(offer)
      {:ok, %Offer{}}

      iex> delete_offer(offer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_offer(%Offer{} = offer) do
    Repo.delete(offer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking offer changes.

  ## Examples

      iex> change_offer(offer)
      %Ecto.Changeset{data: %Offer{}}

  """
  def change_offer(%Offer{} = offer, attrs \\ %{}) do
    Offer.changeset(offer, attrs)
  end
end
