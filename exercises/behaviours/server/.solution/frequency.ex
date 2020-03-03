defmodule Frequency do
  use Server
  @behaviour Server
  @frequencies [10, 11, 12, 13, 14, 15]

  ## API Calls (calling from Client process)
  def start(), do: Server.start(__MODULE__, [])
  def stop(), do: Server.stop(__MODULE__)
  def allocate(), do: Server.call(__MODULE__, {:allocate, self()})
  def deallocate(freq), do: Server.call(__MODULE__, {:deallocate, freq})
  def list_allocated(), do: Server.call(__MODULE__, :list_allocated)
  def list_available(), do: Server.call(__MODULE__, :list_available)

  @impl Server
  def init(_args) do
    {@frequencies, []}
  end

  @impl Server
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
