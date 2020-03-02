defmodule Database do
  use GenServer

  # Client API
  def start(opts) do
    GenServer.start(__MODULE__, opts)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  def insert(_table_name, _key, _value) do
    raise "Insert not implemented"
  end

  def get(_table_name, _key) do
    raise "Get not implemented"
  end

  def update(_table_name, _key, _new_value) do
    raise "Update not implemented"
  end

  def delete(_table_name, _key) do
    raise "Delete not implemented"
  end

  # Server callbacks
  def init(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    # start a named public ETS table; the GenServer will not do much,
    # as it is mostly there to own the ETS table.
    table = :ets.new(name, [:named_table, :public])
    {:ok, table}
  end
end
