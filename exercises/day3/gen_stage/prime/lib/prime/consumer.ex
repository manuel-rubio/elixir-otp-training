defmodule Prime.Consumer do
  use GenStage

  @impl GenStage
  def init([producer, color]) do
    {:consumer, color, subscribe_to: [{producer, max_demand: 1}]}
  end

  @impl GenStage
  def handle_events(events, from, color) do
    event = Enum.join(events, ", ")
    IO.ANSI.format([color, "#{inspect from}:", :reset, " #{event}"])
    |>IO.puts()
    Process.sleep(1_000)

    {:noreply, [], color}
  end
end
