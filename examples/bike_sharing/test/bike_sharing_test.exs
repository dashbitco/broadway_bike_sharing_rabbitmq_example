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

    assert_receive {:ack, ^ref, [%{data: %{bike_id: ^bike_id, point: ["2.0", "2.5"]}}], []}

    assert [%{bike_id: ^bike_id, point: point}] = Repo.all(BikeCoordinate)

    assert point.x == 2.0
    assert point.y == 2.5
  end
end
