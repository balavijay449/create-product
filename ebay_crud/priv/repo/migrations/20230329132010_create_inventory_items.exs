defmodule EbayCrud.Repo.Migrations.CreateInventoryItems do
  use Ecto.Migration

  def change do
    create table(:inventory_items) do
      add :sku, :string
      add :data, :string

      timestamps()
    end
  end
end
