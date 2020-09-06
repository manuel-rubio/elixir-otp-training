defmodule KeyValue do
  use GenServer

  # Client API
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  @spec insert(pid(), key :: term(), value :: term()) :: :ok
  @doc """
  Insert the given value under the given key, but fail if there is
  already a value stored under the given key

  Examples:
      iex> {:ok, pid} = KeyValue.start_link([])
      iex> KeyValue.insert(pid, :key1, :value1)
      :ok
      iex> KeyValue.get(pid, :key1)
      :value1
      iex> KeyValue.stop(pid)
      :ok
  """
  def insert(pid, key, value) do
    GenServer.cast(pid, {:insert, key, value})
  end

  @spec get(pid(), key :: term()) :: :notfound | term()
  @doc """
  Return the value stored under the given key; or return a not found
  if the key is non existent in the data store

  Examples:
      iex> {:ok, pid} = KeyValue.start_link([])
      iex> KeyValue.insert(pid, :key1, :value1)
      :ok
      iex> KeyValue.get(pid, :key1)
      :value1
      iex> KeyValue.get(pid, :key2)
      :notfound
      iex> KeyValue.stop(pid)
      :ok
  """
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @spec update(pid(), key :: term(), value :: term()) :: :ok
  @doc """
  Overwrite the value stored under key

  Examples:
      iex> {:ok, pid} = KeyValue.start_link([])
      iex> KeyValue.insert(pid, :key1, :value1)
      :ok
      iex> KeyValue.get(pid, :key1)
      :value1
      iex> KeyValue.update(pid, :key1, :value2)
      :ok
      iex> KeyValue.get(pid, :key1)
      :value2
      iex> KeyValue.stop(pid)
      :ok
  """
  def update(pid, key, value) do
    GenServer.cast(pid, {:update, key, value})
  end

  @spec delete(pid(), key :: term()) :: :ok
  @doc """
  Remove the key and its value from the data store

  Examples:
      iex> {:ok, pid} = KeyValue.start_link([])
      iex> KeyValue.insert(pid, :key1, :value1)
      :ok
      iex> KeyValue.get(pid, :key1)
      :value1
      iex> KeyValue.delete(pid, :key1)
      :ok
      iex> KeyValue.get(pid, :key1)
      :notfound
      iex> KeyValue.stop(pid)
      :ok
  """
  def delete(pid, key) do
    GenServer.cast(pid, {:delete, key})
  end

  # Server callbacks
  @doc false
  @impl GenServer
  def init(_args) do
    {:ok, %{}}
  end

  @doc false
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

  @doc false
  @impl GenServer
  def handle_call({:get, key}, _from, data) do
    {:reply, Map.get(data, key, :notfound), data}
  end
end
