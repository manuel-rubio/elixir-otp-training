defmodule Mutex do
  use GenStateMachine, callback_mode: [:handle_event_function]

  # Client API
  def start(_opts) do
    GenStateMachine.start(__MODULE__, :na)
  end

  def stop(_pid) do
    raise "Implement me"
  end

  def await(_pid) do
    raise "Implement me"
  end

  def signal(_pid) do
    raise "Implement me"
  end

  # Server callbacks
  def init(:na) do
    initial_loop_data = nil
    {:ok, :free, initial_loop_data}
  end
end
