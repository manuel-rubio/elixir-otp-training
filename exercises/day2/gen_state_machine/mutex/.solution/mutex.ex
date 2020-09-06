defmodule Mutex do
  use GenStateMachine, callback_mode: [:handle_event_function]

  # Client API
  def start(_opts) do
    GenStateMachine.start(__MODULE__, :na)
  end

  def stop(pid) do
    GenStateMachine.stop(pid)
  end

  def await(pid) do
    GenStateMachine.call(pid, :wait)
  end

  def signal(pid) do
    GenStateMachine.call(pid, :signal)
  end

  # Server callbacks
  def init(:na) do
    initial_loop_data = nil
    {:ok, :free, initial_loop_data}
  end

  # Free state
  def handle_event({:call, {pid, _} = from}, :wait, :free, nil) do
    transition_actions = [{:reply, from, :ok}]
    {:next_state, :locked, pid, transition_actions}
  end

  def handle_event({:call, from}, :signal, :free, nil) do
    transition_actions = [{:reply, from, {:error, :unexpected_signal}}]
    {:keep_state_and_data, transition_actions}
  end

  # Locked state
  def handle_event({:call, {same_pid, _} = from}, :signal, :locked, same_pid) do
    transition_actions = [{:reply, from, :ok}]
    {:next_state, :free, nil, transition_actions}
  end

  def handle_event({:call, _from}, :wait, :locked, _loop_data) do
    {:keep_state_and_data, :postpone}
  end
end
