defmodule Frequency do
  use Server

  @moduledoc """
  Frequencies let us to allocate and deallocate frequencies available for
  mobile systems.
  """

  @type freq :: non_neg_integer

  defmodule Data do
    @type t() :: %Data{
      available: [Frequency.freq()],
      allocated: [{Frequency.freq(), pid()}]
    }

    defstruct [
      available: [],
      allocated: []
    ]
  end

  # the hardcoded data:
  @frequencies [10, 11, 12, 13, 14, 15]

  @doc """
  Starts the server. It uses Server.start providing the specific code.
  """
  @spec start() :: {:ok, pid}
  def start(), do: Server.start(__MODULE__, [])

  @doc """
  Stop the server. It uses Server.stop providing the specific code.
  """
  @spec stop() :: :stop
  def stop(), do: Server.stop(__MODULE__)

  @doc """
  Allocate a frequency. It performs a call to the Server providing the message
  which will be handle by this module.
  """
  @spec allocate() :: {:ok, freq} | {:error, :no_frequencies}
  def allocate(), do: Server.call(__MODULE__, {:allocate, self()})

  @doc """
  Deallocate a frequency. It inserts again a frequency inside of the system.
  It performs a call to the Server providing the message which will be handle
  by this module.
  """
  @spec deallocate(freq) :: :ok
  def deallocate(freq), do: Server.call(__MODULE__, {:deallocate, freq})

  @doc """
  Retrieve a list of allocated frequencies. It performs a call to the Server
  providing the message which will be handle by this module.
  """
  @spec list_allocated() :: [{freq, pid}]
  def list_allocated(), do: Server.call(__MODULE__, :list_allocated)

  @doc """
  Retrieve a list of available frequencies. It performs a call to the Server
  providing the message which will be handle by this module.
  """
  @spec list_available() :: [freq]
  def list_available(), do: Server.call(__MODULE__, :list_available)

  @impl Server
  @doc false
  def init(_args) do
    %Data{available: @frequencies}
  end

  @impl Server
  def handle({:allocate, pid}, data) do
    allocate(data, pid)
  end
  def handle({:deallocate, freq}, data) do
    {deallocate(data, freq), :ok}
  end
  def handle(:list_allocated, %Data{allocated: allocated} = data) do
    {data, allocated}
  end
  def handle(:list_available, %Data{available: available} = data) do
    {data, available}
  end

  defp allocate(%Data{available: []} = data, _pid) do
    {data, {:error, :no_frequencies}}
  end
  defp allocate(%Data{available: [freq | available]} = data, pid) do
    allocated = [{freq, pid} | data.allocated]
    {%Data{available: available, allocated: allocated}, {:ok, freq}}
  end

  defp deallocate(%Data{allocated: allocated} = data, freq) do
    allocated = List.keydelete(allocated, freq, 0)
    %Data{available: [freq | data.available], allocated: allocated}
  end
end
