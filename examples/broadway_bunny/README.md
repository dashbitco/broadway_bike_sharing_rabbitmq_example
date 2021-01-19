# BroadwayBunny

This application is an example of a Broadway app using RabbitMQ.
It follows the [RabbitMQ tutorial](https://hexdocs.pm/broadway/rabbitmq.html#content) from
Broadway's documentation.

## Steps to reproduce

We first need to get a RabbitMQ instance running and with a valid queue created.

Using Docker, you can run the server by executing:

    docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management

This command will start the server and will block your terminal, so we need
to open another tab to created the queue. In your new terminal tab/window, type:

    rabbitmqadmin declare queue name=my_queue durable=true

You can see that the queue "my_queue" was created by running `rabbitmqctl list_queues` in the
same window.

### Running the app

After creating the queue, with the server running, you can execute the app in another window
with `iex -S mix`.

To simulate events, first open a connection and then fire some messages:

```elixir
{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "my_queue", durable: true)

Enum.each(1..5000, fn i ->
  AMQP.Basic.publish(channel, "", "my_queue", "message #{i}")
end)

AMQP.Connection.close(connection)
```

That is it! You can find more details and configuration at [Broadway RabbitMQ documentation](https://hexdocs.pm/broadway_rabbitmq/).
Happy hacking!
