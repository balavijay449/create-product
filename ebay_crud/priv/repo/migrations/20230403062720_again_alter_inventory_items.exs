defmodule EbayCrud.Repo.Migrations.AgainAlterInventoryItems do
  use Ecto.Migration

  def change do
    alter table(:inventory_items) do
      add :values, :map
    end
  end
end
