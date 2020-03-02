defmodule Cache do
  @moduledoc """
  Architect a multi layer cache system that request elements from a
  shared resource and cache them. The cache should have two layers,
  and it should flip the current generation to the old, and create a
  new generation in the process.
  """

  use GenServer

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  # Server callbacks
  def init(_arg) do
    initial_state = nil
    {:ok, initial_state}
  end
end
