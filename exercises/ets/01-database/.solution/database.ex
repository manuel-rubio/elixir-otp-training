defmodule Database do
  use GenServer

  # Client API
  def start(opts) do
    GenServer.start(__MODULE__, opts)
  end

  def insert(table, key, value) do
    case :ets.insert_new(table, {key, value}) do
      true ->
        :ok

      false ->
        {:error, :key_already_exists}
    end
  end

  def get(table, key) do
    case :ets.lookup(table, key) do
      [{^key, value}] ->
        {:ok, value}

      [] ->
        :not_found
    end
  end

  def update(table, key, new_value) do
    case :ets.update_element(table, key, {2, new_value}) do
      true ->
        :ok

      false ->
        :not_found
    end
  end

  def delete(table, key) do
    case :ets.delete(table, key) do
      true ->
        :ok
    end
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
