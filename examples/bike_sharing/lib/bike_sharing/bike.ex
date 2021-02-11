defmodule BikeSharing.Bike do
  use BikeSharing.Schema
  import Ecto.Changeset

  schema "bikes" do
    field(:model, :string)

    timestamps()
  end

  @doc """
  A bike changeset.

  It validates the model of the bike
  """
  def changeset(bike, attrs) do
    bike
    |> cast(attrs, [:model])
    |> validate_length(:model, min: 3, max: 25)
  end
end
