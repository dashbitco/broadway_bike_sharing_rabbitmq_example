{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "bikes_queue", durable: true)

sample = File.read!("./priv/trajectories_sample.csv")
[_header | lines] = String.split(sample, "\n")

for line <- lines, do: AMQP.Basic.publish(channel, "", "bikes_queue", line)

AMQP.Connection.close(connection)
