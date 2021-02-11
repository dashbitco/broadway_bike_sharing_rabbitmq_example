import Config

config :bike_sharing,
  ecto_repos: [BikeSharing.Repo]

config :bike_sharing, BikeSharing.Repo, migration_timestamps: [type: :utc_datetime_usec]

import_config "#{Mix.env()}.exs"
