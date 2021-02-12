defmodule BikeSharing.Repo.Migrations.CreateBikeCoordinates do
  use Ecto.Migration

  def change do
    create table(:bike_coordinates) do
      add :bike_id, references(:bikes, on_delete: :delete_all), null: false
      add :point, :geometry, null: false

      timestamps(updated_at: false)
    end
  end
end
