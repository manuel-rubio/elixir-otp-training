defmodule Prime.Consumer do
  use GenStage

  def init([producer, color]) do
    {:consumer, color, subscribe_to: [{producer, max_demand: 1}]}
  end

  def handle_events([event], from, color) do
    IO.ANSI.format([color, "#{inspect from}:", :reset, " #{event}"])
    |>IO.puts()
    Process.sleep(1_000)

    {:noreply, [], color}
  end
end
