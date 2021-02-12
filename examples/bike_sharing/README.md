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

After creating the queue, with RabbitMQ server running, you can execute the app in another window
with `iex -S mix`. It will be waiting for events.

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

You can test with a sample set of data by running the script "priv/publish_sample_events.exs":

    mix run --no-halt priv/publish_sample_events.exs

#### Running with Docker Compose

If you don't want to install PostgreSQL or you don't want to run RabbitMQ by hand, you can try
to run this project using Docker compose.

Just run: `docker-compose up`
It will take a while in the first time. You need to run `docker-compose build` everytime you
change a file in the project.


## Conclusion

You can play with the options and the pipeline by editing the `lib/bike_sharing.ex` file.
In the real world we need to analyse and tweak Broadway options for maximum performance.

That is it! You can find more details and configuration at [Broadway RabbitMQ documentation](https://hexdocs.pm/broadway_rabbitmq/)
and [Broadway RabbitMQ Guide](https://hexdocs.pm/broadway/rabbitmq.html).
Happy hacking!
