defmodule EbayCrud.Repo.Migrations.CreateOffers do
  use Ecto.Migration

  def change do
    create table(:offers) do
      add :sku, :string
      add :values, :map
      add :offer_id, :string
      add :is_published, :boolean

      timestamps()
    end
  end
end
