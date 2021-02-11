defmodule BikeSharing.BikeCoordinate do
  use BikeSharing.Schema
  import Ecto.Changeset

  schema "bike_coordinates" do
    field(:point, Ecto.PointType)

    belongs_to(:bike, BikeSharing.Bike)

    timestamps(updated_at: false)
  end

  def changeset(coordinate, attrs) do
    cast(coordinate, attrs, [:point])
  end
end
