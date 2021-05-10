defmodule BikeSharingTest do
  use BikeSharing.DataCase

  alias BikeSharing.Bike
  alias BikeSharing.BikeCoordinate

  defp insert_bike(model) do
    {:ok, bike} = Repo.insert(%Bike{model: model})
    bike
  end

  test "saves coordinates" do
    %{id: bike_id} = insert_bike("caloi")

    ref = Broadway.test_message(BikeSharing, "1,2.0,2.5,#{bike_id},\"2021-02-12 15:34\"")

    assert_receive {:ack, ^ref, [%{data: %{bike_id: ^bike_id, point: point}}], []}

    assert %Geo.Point{coordinates: {2.0, 2.5}} = point

    assert [%{bike_id: ^bike_id, point: inserted_point}] = Repo.all(BikeCoordinate)

    assert %Geo.Point{coordinates: {2.0, 2.5}} = inserted_point
  end
end
