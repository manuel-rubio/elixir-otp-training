defmodule Frequency do
  use Server

  @moduledoc """
  Frequencies let us to allocate and deallocate frequencies available for
  mobile systems.
  """

  # because of the way of compilation for behaviours, we have to
  # write this here:
  @behaviour Server

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
  @spec allocate() :: {:ok, non_neg_integer} | {:error, :no_frequencies}
  def allocate(), do: Server.call(__MODULE__, {:allocate, self()})

  @doc """
  Deallocate a frequency. It inserts again a frequency inside of the system.
  It performs a call to the Server providing the message which will be handle
  by this module.
  """
  @spec deallocate() :: :ok
  def deallocate(freq), do: Server.call(__MODULE__, {:deallocate, freq})

  @doc """
  Retrieve a list of allocated frequencies. It performs a call to the Server
  providing the message which will be handle by this module.
  """
  @spec list_allocated() :: [{non_neg_integer, pid}]
  def list_allocated(), do: Server.call(__MODULE__, :list_allocated)

  @doc """
  Retrieve a list of available frequencies. It performs a call to the Server
  providing the message which will be handle by this module.
  """
  @spec list_available() :: [non_neg_integer]
  def list_available(), do: Server.call(__MODULE__, :list_available)

  @impl Server
  @doc false
  def init(_args) do
    {@frequencies, []}
  end

  @impl Server
  @doc false
  def handle({:allocate, pid}, frequencies) do
    # implement this performing the frequencies allocation
    {frequencies, {:error, :not_implemented}}
  end
  def handle({:deallocate, freq}, frequencies) do
    # implement this performing the frequencies deallocation
    {frequencies, {:error, :not_implemented}}
  end
  def handle(:list_allocated, {_, allocated} = frequencies) do
    # implement this performing the return of the allocated info
    {frequencies, {:error, :not_implemented}}
  end
  def handle(:list_available, {available, _} = frequencies) do
    # implement this performing the return of the available info
    {frequencies, {:error, :not_implemented}}
  end
end
