defmodule EbayCrud.InventoryTest do
  use EbayCrud.DataCase

  alias EbayCrud.Inventory

  describe "inventory_items" do
    alias EbayCrud.Inventory.InventoryItem

    import EbayCrud.InventoryFixtures

    @invalid_attrs %{data: nil, sku: nil}

    test "list_inventory_items/0 returns all inventory_items" do
      inventory_item = inventory_item_fixture()
      assert Inventory.list_inventory_items() == [inventory_item]
    end

    test "get_inventory_item!/1 returns the inventory_item with given id" do
      inventory_item = inventory_item_fixture()
      assert Inventory.get_inventory_item!(inventory_item.id) == inventory_item
    end

    test "create_inventory_item/1 with valid data creates a inventory_item" do
      valid_attrs = %{data: "some data", sku: "some sku"}

      assert {:ok, %InventoryItem{} = inventory_item} = Inventory.create_inventory_item(valid_attrs)
      assert inventory_item.data == "some data"
      assert inventory_item.sku == "some sku"
    end

    test "create_inventory_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_inventory_item(@invalid_attrs)
    end

    test "update_inventory_item/2 with valid data updates the inventory_item" do
      inventory_item = inventory_item_fixture()
      update_attrs = %{data: "some updated data", sku: "some updated sku"}

      assert {:ok, %InventoryItem{} = inventory_item} = Inventory.update_inventory_item(inventory_item, update_attrs)
      assert inventory_item.data == "some updated data"
      assert inventory_item.sku == "some updated sku"
    end

    test "update_inventory_item/2 with invalid data returns error changeset" do
      inventory_item = inventory_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_inventory_item(inventory_item, @invalid_attrs)
      assert inventory_item == Inventory.get_inventory_item!(inventory_item.id)
    end

    test "delete_inventory_item/1 deletes the inventory_item" do
      inventory_item = inventory_item_fixture()
      assert {:ok, %InventoryItem{}} = Inventory.delete_inventory_item(inventory_item)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_inventory_item!(inventory_item.id) end
    end

    test "change_inventory_item/1 returns a inventory_item changeset" do
      inventory_item = inventory_item_fixture()
      assert %Ecto.Changeset{} = Inventory.change_inventory_item(inventory_item)
    end
  end

  describe "offers" do
    alias EbayCrud.Inventory.Offer

    import EbayCrud.InventoryFixtures

    @invalid_attrs %{offer_id: nil, sku: nil, values: nil}

    test "list_offers/0 returns all offers" do
      offer = offer_fixture()
      assert Inventory.list_offers() == [offer]
    end

    test "get_offer!/1 returns the offer with given id" do
      offer = offer_fixture()
      assert Inventory.get_offer!(offer.id) == offer
    end

    test "create_offer/1 with valid data creates a offer" do
      valid_attrs = %{offer_id: "some offer_id", sku: "some sku", values: %{}}

      assert {:ok, %Offer{} = offer} = Inventory.create_offer(valid_attrs)
      assert offer.offer_id == "some offer_id"
      assert offer.sku == "some sku"
      assert offer.values == %{}
    end

    test "create_offer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_offer(@invalid_attrs)
    end

    test "update_offer/2 with valid data updates the offer" do
      offer = offer_fixture()
      update_attrs = %{offer_id: "some updated offer_id", sku: "some updated sku", values: %{}}

      assert {:ok, %Offer{} = offer} = Inventory.update_offer(offer, update_attrs)
      assert offer.offer_id == "some updated offer_id"
      assert offer.sku == "some updated sku"
      assert offer.values == %{}
    end

    test "update_offer/2 with invalid data returns error changeset" do
      offer = offer_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_offer(offer, @invalid_attrs)
      assert offer == Inventory.get_offer!(offer.id)
    end

    test "delete_offer/1 deletes the offer" do
      offer = offer_fixture()
      assert {:ok, %Offer{}} = Inventory.delete_offer(offer)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_offer!(offer.id) end
    end

    test "change_offer/1 returns a offer changeset" do
      offer = offer_fixture()
      assert %Ecto.Changeset{} = Inventory.change_offer(offer)
    end
  end
end
