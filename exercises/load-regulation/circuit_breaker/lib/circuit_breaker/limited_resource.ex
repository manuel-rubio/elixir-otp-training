defmodule CircuitBreaker.LimitedResource do
  use GenServer

  defstruct tokens: 10, token_rate: 10_000

  # Client API
  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def request(name_or_pid \\ __MODULE__) do
    GenServer.call(name_or_pid, :request)
  end

  # Server callbacks
  def init(opts) do
    initial_state = struct(__MODULE__, opts)
    {:ok, initial_state}
  end

  def handle_call(:request, _from, %__MODULE__{tokens: 0} = state) do
    reply = {:error, :overloaded}
    {:reply, reply, state}
  end

  def handle_call(:request, _from, %__MODULE__{tokens: n} = state) when n > 0 do
    reply = :ok
    _timer_ref = Process.send_after(self(), :produce_token, state.token_rate)
    {:reply, reply, %__MODULE__{state | tokens: n - 1}}
  end

  def handle_info(:produce_token, %__MODULE__{tokens: n} = state) do
    {:noreply, %__MODULE__{state | tokens: n + 1}}
  end
end
