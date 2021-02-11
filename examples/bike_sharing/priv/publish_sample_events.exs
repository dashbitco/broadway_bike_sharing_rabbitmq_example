conn_opts = Application.fetch_env!(:bike_sharing, :rabbitmq_connection)

# Wait for RabbitMQ connection on Docker
if File.exists?("/.dockerenv") do
  Process.sleep(5_000)
end

{:ok, connection} = AMQP.Connection.open(conn_opts)
{:ok, channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "bikes_queue", durable: true)

sample = File.read!("./priv/trajectories_sample.csv")
[_header | lines] = String.split(sample, "\n")

for line <- lines, do: AMQP.Basic.publish(channel, "", "bikes_queue", line)

AMQP.Connection.close(connection)
