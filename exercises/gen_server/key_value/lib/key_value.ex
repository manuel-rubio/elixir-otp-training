defmodule KeyValue do
  @moduledoc """
  KeyValue is a dictionary based on GenServer, it let us to store
  information inside of the process state data in a map form and
  retrieve the information based on the key provided when we store
  it.

  ## Exercise

  You should to implement the API calls to the GenServer using call
  or cast depending on the case and the functionality inside of the
  server corresponding to what we want to achieve.
  """
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
  def insert(_pid, _key, _value) do
    raise "implement me"
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
  def get(_pid, _key) do
    raise "implement me"
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
  def update(_pid, _key, _value) do
    raise "implement me"
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
  def delete(_pid, _key) do
    raise "implement me"
  end

  @doc false
  @impl GenServer
  def init(:na) do
    {:ok, nil}
  end
end
