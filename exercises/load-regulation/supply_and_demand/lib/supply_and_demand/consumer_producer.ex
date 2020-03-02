defmodule SupplyAndDemand.ConsumerProducer do
  use GenStage

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    initial_state = :na # the initial state is not important here
    {:producer_consumer, :na, subscribe_to: [{SupplyAndDemand.Producer, max_demand: 50}]}
  end

  def handle_events(events, _from, loop_data) do
    events = for event <- events, do: event * 2
    {:noreply, events, loop_data}
  end
end
