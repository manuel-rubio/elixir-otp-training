defmodule Frequency do
  use Server
  @behaviour Server
  @frequencies [10, 11, 12, 13, 14, 15]

  def allocate(), do: Server.call(__MODULE__, {:allocate, self()})
  def deallocate(freq), do: Server.call(__MODULE__, {:deallocate, freq})

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
