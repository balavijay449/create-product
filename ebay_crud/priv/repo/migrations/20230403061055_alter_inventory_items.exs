defmodule EbayCrud.Repo.Migrations.AlterInventoryItems do
  use Ecto.Migration

  def change do
    alter table(:inventory_items) do
      add :values, :map
    end
    create(unique_index(:inventory_items, :sku))
  end
end
