defmodule Frequency do

  @moduledoc """
  Frequencies let us to allocate and deallocate frequencies available for
  mobile systems. For further information check Frequency.Worker.
  """

  @worker Frequency.Worker

  @type freq :: non_neg_integer

  @doc """
  Starts the server. It uses Server.start providing the specific code.
  """
  @spec start() :: {:ok, pid}
  defdelegate start(), to: Frequency.Worker

  # @doc """
  # Starts the server. It uses Server.start providing the specific code.
  # """
  # @spec start_link() :: {:ok, pid}
  # defdelegate start_link(), to: Frequency.Worker

  @doc """
  Stop the server. It uses Server.stop providing the specific code.
  """
  @spec stop() :: :stop
  def stop(), do: Server.stop(@worker)

  @doc """
  Allocate a frequency. It performs a call to the Server providing the message
  which will be handle by this module.
  """
  @spec allocate() :: {:ok, freq} | {:error, :no_frequencies}
  def allocate(), do: Server.call(@worker, {:allocate, self()})

  @doc """
  Deallocate a frequency. It inserts again a frequency inside of the system.
  It performs a call to the Server providing the message which will be handle
  by this module.
  """
  @spec deallocate(freq) :: :ok
  def deallocate(freq), do: Server.call(@worker, {:deallocate, freq})

  @doc """
  Retrieve a list of allocated frequencies. It performs a call to the Server
  providing the message which will be handle by this module.
  """
  @spec list_allocated() :: [{freq, pid}]
  def list_allocated(), do: Server.call(@worker, :list_allocated)

  @doc """
  Retrieve a list of available frequencies. It performs a call to the Server
  providing the message which will be handle by this module.
  """
  @spec list_available() :: [freq]
  def list_available(), do: Server.call(@worker, :list_available)
end
