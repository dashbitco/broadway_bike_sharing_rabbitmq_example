defmodule BikeSharing.Repo do
  use Ecto.Repo,
    otp_app: :bike_sharing,
    adapter: Ecto.Adapters.Postgres
end
