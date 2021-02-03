defmodule Syslog.Console do
  use GenStage

  @impl GenStage
  def init([producer]) do
    {:consumer, [], subscribe_to: [{producer, max_demand: 1}]}
  end

  @impl GenStage
  def handle_events([event], _from, state) do
    IO.ANSI.format([:inverse, "CONSUME", :reset, "\n", event])
    |> IO.puts()

    {:noreply, [], state}
  end
end
