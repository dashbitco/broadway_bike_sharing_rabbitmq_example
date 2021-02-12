import Config

config :bike_sharing, BikeSharing.Repo,
  username: "postgres",
  password: "postgres",
  database: "bike_sharing_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bike_sharing, producer_module: {Broadway.DummyProducer, []}

config :logger, backends: []
