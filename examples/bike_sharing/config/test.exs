import Config

# Configure your database
config :bike_sharing, BikeSharing.Repo,
  username: "postgres",
  password: "postgres",
  database: "bike_sharing_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
