defmodule Mutex do
  @moduledoc """
  Mutex let us to configure a lock for executing in exclusive way a critical
  code while others are waiting for the release of the mutex to get it for
  them.

  This State Machine should store the PID for the process which has the lock
  inside of the state and, when it is receiving a signal from that process,
  the calling of the signal function, then it's moving to the unlock state.

  All of the events for await could be postponed. This way they are not going
  to be processed until we back to the unlock state.

  ```
    signal                             await
  +-------+     +------------------+  +------+
  |       |     |       await      |  |      |
  |       |     |                  v  |      |
  |    +----------+             +--------+   |
  +--->+ unlocked |             | locked +<--+
       +----------+             +--------+
             |                       |
             |         signal        |
             +-----------------------+
  ```

  """
  use GenStateMachine, callback_mode: [:handle_event_function]

  @spec start([]) :: {:ok, pid()}
  @doc """
  Starts the state machine.
  """
  def start(args) do
    GenStateMachine.start(__MODULE__, args)
  end

  @spec stop(pid()) :: :ok
  @doc """
  Stops the state machine
  """
  def stop(pid) do
    GenStateMachine.stop(pid)
  end

  @spec await(pid()) :: :ok
  @doc """
  Await until the state machine returns the reply. This way we ensure we have
  the mutex for us until we send back the signal.
  """
  def await(pid) do
    GenStateMachine.call(pid, :await)
  end

  @spec signal(pid()) :: :ok
  @doc """
  Releases the mutex. Letting the mutex to choose another process to lock it
  again.
  """
  def signal(pid) do
    GenStateMachine.call(pid, :signal)
  end

  # Server callbacks
  @doc false
  @impl GenStateMachine
  def init([]) do
    {:ok, :unlocked, []}
  end

  @impl GenStateMachine
  def handle_event({:call, from}, :await, :unlocked, data) do
    {:next_state, :locked, data, [{:reply, from, :ok}]}
  end

  def handle_event({:call, from}, :signal, :unlocked, _data) do
    actions = [{:reply, from, {:error, :unexpected_signal}}]
    {:keep_state_and_data, actions}
  end

  def handle_event({:call, _from}, :await, :locked, _data) do
    {:keep_state_and_data, [:postpone]}
  end

  def handle_event({:call, from}, :signal, :locked, data) do
    actions = [{:reply, from, :ok}]
    {:next_state, :unlocked, data, actions}
  end
end
