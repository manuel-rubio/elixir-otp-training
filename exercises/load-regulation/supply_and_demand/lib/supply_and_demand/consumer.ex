defmodule SupplyAndDemand.Consumer do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, nil, subscribe_to: [{SupplyAndDemand.ConsumerProducer, max_demand: 50}]}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    :timer.sleep(1000)

    # Inspect the events.
    IO.inspect(events, label: __MODULE__)

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end
