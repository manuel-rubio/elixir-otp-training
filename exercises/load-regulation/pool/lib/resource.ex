defmodule Resource do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def get_n(pid), do: GenServer.call(pid, :get_n)

  @impl GenServer
  def init([]) do
    {:ok, 100}
  end

  @impl GenServer
  def handle_call(_whatever, _from, n) do
    Process.sleep(1_500)
    {:reply, n+1, n+1}
  end
end
