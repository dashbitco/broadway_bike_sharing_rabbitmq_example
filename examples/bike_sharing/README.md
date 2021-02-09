# BikeSharing

This is an example of a Broadway application using RabbitMQ.

The idea is to simulate a bike sharing application that receives coordinates
of bikes in a city and saves those coordinates through a Broadway pipeline.

## Steps to reproduce

We first need to get a RabbitMQ instance running and with a valid queue created.

Using Docker, you can run the server by executing:

    docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management

This command will start the server and will block your terminal, so we need
to open another tab to created the queue. To do that we will enter in the container that is running:

    docker exec -it rabbitmq /bin/bash

And then, we create our queue:

    rabbitmqadmin declare queue name=bikes_queue durable=true

You can see that the queue "bikes_queue" was created by running `rabbitmqctl list_queues` in the
same window.

### Running the app

After creating the queue, with the server running, you can execute the app in another window
with `iex -S mix`.

To simulate events, first open a connection and then fire some messages:

```elixir
{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "bikes_queue", durable: true)

Enum.each(1..5000, fn i ->
  AMQP.Basic.publish(channel, "", "bikes_queue", "message #{i}")
end)

AMQP.Connection.close(connection)
```

That is it! You can find more details and configuration at [Broadway RabbitMQ documentation](https://hexdocs.pm/broadway_rabbitmq/).
Happy hacking!
