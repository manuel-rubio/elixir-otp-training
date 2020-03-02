defmodule Cache.Resource do
  @moduledoc """
  A server that mock some heavy work in a shared, single resource
  """

  use GenServer

  # Client API
  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, :na, name: name)
  end

  def fetch(name_or_pid \\ __MODULE__, subject) do
    GenServer.call(name_or_pid, {:fetch, subject})
  end

  # Server callbacks
  def init(:na) do
    {:ok, []}
  end

  def handle_call({:fetch, subject}, _from, state) when is_binary(subject) do
    # simulate "heavy" work
    100..750 |> Enum.random() |> Process.sleep()
    {:reply, String.reverse(subject), state}
  end

  def handle_call({:fetch, subject}, _from, state) do
    # simulate "heavy" work
    100..750 |> Enum.random() |> Process.sleep()
    {:reply, String.reverse("#{inspect subject}"), state}
  end
end
