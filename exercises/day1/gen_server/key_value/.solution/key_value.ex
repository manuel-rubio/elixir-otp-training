defmodule KeyValue do
  use GenServer

  # Client API
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  @doc """
  Insert the given value under the given key, but fail if there is
  already a value stored under the given key
  """
  def insert(pid, key, value) do
    GenServer.cast(pid, {:insert, key, value})
  end

  @doc """
  Return the value stored under the given key; or return a not found
  if the key is non existent in the data store
  """
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @doc """
  Overwrite the value stored under key
  """
  def update(pid, key, value) do
    GenServer.cast(pid, {:update, key, value})
  end

  @doc """
  Remove the key and its value from the data store
  """
  def delete(pid, key) do
    GenServer.cast(pid, {:delete, key})
  end

  # Server callbacks
  @impl GenServer
  def init(_args) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:insert, key, value}, data) do
    {:noreply, Map.put_new(data, key, value)}
  end
  def handle_cast({:update, key, value}, data) do
    {:noreply, Map.put(data, key, value)}
  end
  def handle_cast({:delete, key}, data) do
    {:noreply, Map.delete(data, key)}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, data) do
    {:reply, Map.get(data, key), data}
  end
end
