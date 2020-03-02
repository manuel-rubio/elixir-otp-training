defmodule Rpn do
  @moduledoc """
  A GenServer that implement a reverse polish notation calculator

  Should have a public interface that implement a

  - start() -> {:ok, pid} | ...
  - stop(pid) -> :ok
  - push(pid, token) -> {:ok, token}

  """

  use GenServer

  # Client API
  def start(args) do
    GenServer.start(__MODULE__, args)
  end

  def stop(_server_pid) do
    raise "Implement me"
  end

  def push(_server_pid, _token) do
    raise "Implement me"
  end

  # Server callbacks
  def init(args) do
    {:ok, args}
  end
end
