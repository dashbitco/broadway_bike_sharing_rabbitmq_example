defmodule BikeSharing do
  @moduledoc """
  This is an app that reads coordinates from bike sharing.

  A Broadway example using RabbitMQ that ingest coordinates and save them
  in the database for future processing.
  """

  use Broadway
  require Logger

  alias Broadway.Message
  alias BikeSharing.Repo
  alias BikeSharing.BikeCoordinate

  @queue "bikes_queue"

  def start_link(opts) do
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
             connection: [
               host: Keyword.fetch!(opts, :host)
             ],
             on_failure: :reject_and_requeue
           ]},
        concurrency: 2
      ],
      processors: [
        default: [concurrency: 50]
      ],
      batchers: [
        default: [batch_size: 10, batch_timeout: 1500, concurrency: 5],
        parse_error: [batch_size: 10, concurrency: 2, batch_timeout: 1500]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{} = message, _) do
    message =
      Message.update_data(message, fn data ->
        case String.split(data, ",") do
          [_, lat, lng, bike_id, _timestamp] ->
            %{bike_id: String.to_integer(bike_id), point: [lat, lng]}

          _ ->
            data
        end
      end)

    if is_binary(message.data) do
      # Move the message to a batcher of errors.
      Message.put_batcher(message, :parse_error)
    else
      message
    end
  end

  @impl true
  def handle_batch(:default, messages, _, _) do
    Logger.debug("in default batcher")
    Logger.debug(fn -> "size: #{length(messages)}" end)
    Enum.map(messages, &Logger.debug("message: #{inspect(&1.data)}"))

    {rows, _} =
      Repo.insert_all(
        BikeCoordinate,
        Enum.map(messages, &Map.put(&1.data, :inserted_at, DateTime.utc_now()))
      )

    Logger.debug("saved rows: #{rows}")

    messages
  end

  def handle_batch(:parse_error, messages, _, _) do
    Logger.info("in parse error batcher")
    Logger.info(fn -> "size: #{length(messages)}" end)
    Logger.info("the following messages with errors will be dropped")

    Enum.map(messages, &Logger.info("message: #{inspect(&1.data)}"))

    messages
  end
end
