defmodule Batcher do
  @enforce_keys [:fun]
  defstruct interval: 5_000, fun: nil

  def start(fun, interval \\ 5_000) do
    spawn(__MODULE__, :init, {fun, interval})
  end

  def stop(pid) do
    send(pid, :stop)
    :ok
  end

  def process(pid, message) do
    send(pid, {:task, message})
    :ok
  end

  @doc false
  def init({fun, interval}) do
    initial_loop_data = %__MODULE__{interval: interval, fun: fun}
    do_loop(initial_loop_data)
  end

  defp do_loop(%__MODULE__{interval: interval} = state) do
    receive do
      :stop ->
        do_process(state)
        :ok
    after
      interval ->
        state = do_process(state)
        do_loop(state)
    end
  end

  defp do_process(%__MODULE__{fun: fun} = state) do
    receive do
      {:task, arg} ->
        _ = fun.(arg)
        do_process(state)
    after
      0 ->
        state
    end
  end
end
