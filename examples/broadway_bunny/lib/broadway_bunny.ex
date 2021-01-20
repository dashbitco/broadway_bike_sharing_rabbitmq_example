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
             ],
             on_failure: :reject_and_requeue
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
    message
    |> Message.update_data(fn data -> String.upcase(data) end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    IO.puts("in batch")
    IO.puts("size: #{length(messages)}")
    IO.inspect(Enum.map(messages, & &1.data), label: "messages")

    messages
  end
end
