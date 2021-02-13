defmodule BikeSharing.Repo.Migrations.CreateBikes do
  use Ecto.Migration

  def change do
    create table(:bikes) do
      add :model, :string, null: false

      timestamps()
    end
  end
end
