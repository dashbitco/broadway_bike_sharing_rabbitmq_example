import Config

# Configure your database
config :bike_sharing, BikeSharing.Repo,
  username: "postgres",
  password: "postgres",
  database: "bike_sharing_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :bike_sharing, :rabbitmq_connection, host: "localhost"

if File.exists?("/.dockerenv") do
  config :bike_sharing, BikeSharing.Repo, hostname: "db"
  config :bike_sharing, :rabbitmq_connection, host: "rabbitmq"
end
