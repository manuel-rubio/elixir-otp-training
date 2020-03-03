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
  def insert(_pid, _key, _value) do
    raise "implement me"
  end

  @doc """
  Return the value stored under the given key; or return a not found
  if the key is non existent in the data store
  """
  def get(_pid, _key) do
    raise "implement me"
  end

  @doc """
  Overwrite the value stored under key
  """
  def update(_pid, _key, _value) do
    raise "implement me"
  end

  @doc """
  Remove the key and its value from the data store
  """
  def delete(_pid, _key) do
    raise "implement me"
  end

  # Server callbacks
  def init(:na) do
    {:ok, nil}
  end
end
