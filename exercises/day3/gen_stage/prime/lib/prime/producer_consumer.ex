defmodule Prime.ProducerConsumer do
  use GenStage

  def init([producer, color]) do
    {:producer_consumer,
      color,
      dispatcher: GenStage.DemandDispatcher,
      subscribe_to: [{producer, max_demand: 10}]}
  end

  def handle_events(events, _from, color) do
    print_numbers = Enum.join(events, ", ")
    IO.ANSI.format([color, :inverse, " -- STORING -- ", :reset, "\n", print_numbers])
    |>IO.puts()
    {:noreply, events, color}
  end
end
