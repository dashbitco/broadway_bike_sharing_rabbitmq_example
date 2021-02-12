import Config

# This is an additional config file that take care
# of adapting the environment to work inside Docker compose.

{broadway_module, opts} = Application.get_env(:bike_sharing, :producer_module)

config :bike_sharing,
  producer_module: {broadway_module, Keyword.put(opts, :connection, host: "rabbitmq")}

config :bike_sharing, BikeSharing.Repo, hostname: "db"
