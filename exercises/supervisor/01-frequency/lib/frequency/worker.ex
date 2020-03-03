defmodule Frequency.Worker do
  use Server

  @moduledoc """
  Frequencies let us to allocate and deallocate frequencies available for
  mobile systems. This module is in charge of the Server running code.
  """

  # the hardcoded data:
  @frequencies [10, 11, 12, 13, 14, 15]

  @spec start() :: {:ok, pid}
  @doc false
  def start(), do: Server.start(__MODULE__, [])

  @spec start() :: {:ok, pid}
  @doc false
  def start_link(), do: Server.start_link(__MODULE__, [])

  @impl Server
  @doc false
  def init(_args) do
    {@frequencies, []}
  end

  @impl Server
  @doc false
  def handle({:allocate, pid}, frequencies) do
    allocate(frequencies, pid)
  end
  def handle({:deallocate, freq}, frequencies) do
    {deallocate(frequencies, freq), :ok}
  end
  def handle(:list_allocated, {_, allocated} = frequencies) do
    {frequencies, allocated}
  end
  def handle(:list_available, {available, _} = frequencies) do
    {frequencies, available}
  end

  defp allocate({[], _} = frequencies, _pid) do
    {frequencies, {:error, :no_frequencies}}
  end
  defp allocate({[freq|frequencies], allocated}, pid) do
    allocated = [{freq, pid}|allocated]
    {{frequencies, allocated}, {:ok, freq}}
  end

  defp deallocate({frequencies, allocated}, freq) do
    allocated = List.keydelete(allocated, freq, 0)
    {[freq|frequencies], allocated}
  end
end
