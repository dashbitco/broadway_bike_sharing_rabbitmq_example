import Config

# This is an additional config file that take care
# of adapting the environment to work inside Docker compose.

config :bike_sharing,
  producer_module:
    {BroadwayRabbitMQ.Producer,
     [
       queue: "bikes_queue",
       connection: [
         host: "rabbitmq"
       ],
       qos: [
         prefetch_count: 50
       ],
       on_failure: :reject_and_requeue
     ]}

config :bike_sharing, BikeSharing.Repo, hostname: "db"
