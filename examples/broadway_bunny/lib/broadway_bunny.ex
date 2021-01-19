defmodule BroadwayBunny do
  @moduledoc """
  This is the entrypoint of this project.

  A Broadway example using RabbitMQ.
  """

  use Broadway

  alias Broadway.Message

  @queue "my_queue"

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           [
             queue: @queue,
             qos: [
               prefetch_count: 50
             ]
           ]},
        concurrency: 2
      ],
      processors: [
        default: [concurrency: 50]
      ],
      batchers: [
        default: [batch_size: 10, batch_timeout: 1500, concurrency: 5]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{} = message, _) do
    IO.puts(message.data)

    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    IO.puts("in batch")
    IO.puts("size: #{length(messages)}")

    messages
  end
end
