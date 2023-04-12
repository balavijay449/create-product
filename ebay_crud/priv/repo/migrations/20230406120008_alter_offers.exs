defmodule EbayCrud.Repo.Migrations.AlterOffers do
  use Ecto.Migration

  def change do
    alter table("offers") do
      add :listing_id, :string
    end
  end
end
