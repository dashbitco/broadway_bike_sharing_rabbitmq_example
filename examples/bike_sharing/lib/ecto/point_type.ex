defmodule Ecto.PointType do
  @behaviour Ecto.Type

  @moduledoc """
  This is a special Ecto type to deal with cartesian points.
  """

  alias Postgrex.Point

  def type, do: Point

  def cast(%Point{} = point), do: {:ok, point}

  def cast([lat, lng]) when is_float(lat) and is_float(lng) do
    {:ok, %Point{x: lat, y: lng}}
  end

  def cast([lat, lng]) when is_binary(lat) and is_binary(lng) do
    lat = String.to_float(lat)
    lng = String.to_float(lng)

    {:ok, %Point{x: lat, y: lng}}
  end

  def cast(point_as_string) when is_binary(point_as_string) do
    [lat, lng] =
      point_as_string
      |> String.split(",")
      |> Enum.map(&String.to_float(&1))

    {:ok, %Point{x: lat, y: lng}}
  end

  def cast(_), do: :error

  def load(data), do: {:ok, data}

  def dump(%Point{x: x, y: y} = point) when is_float(x) and is_float(y), do: {:ok, point}

  def dump(%Point{x: x, y: y} = point) do
    {:ok, %{point | x: String.to_float(x), y: String.to_float(y)}}
  end

  def dump([lat, lng]) when is_float(lat) and is_float(lng), do: {:ok, %Point{x: lat, y: lng}}

  def dump([lat, lng]) do
    {:ok, %Point{x: String.to_float(lat), y: String.to_float(lng)}}
  end

  def dump(_), do: :error

  def embed_as(_), do: :self

  def equal?(%Point{} = point_a, %Point{} = point_b) do
    point_a.x == point_b.x && point_a.y == point_b.y
  end

  def equal?(_, _), do: false
end
