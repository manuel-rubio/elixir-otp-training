defmodule Rpn do
  @moduledoc """
  A GenServer that implement a reverse polish notation calculator

  Should have a public interface that implement a

  - start_link() -> {:ok, pid} | ...
  - stop(pid) -> :ok
  - push(pid, token) -> {:ok, token}

  """

  use GenServer

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :na)
  end

  def stop(server_pid) do
    GenServer.stop(server_pid)
  end

  def push(server_pid, token) do
    GenServer.call(server_pid, {:push_token, token})
  end

  # Server callbacks
  def init(:na) do
    {:ok, []}
  end

  def handle_call({:push_token, n}, _from, stack) when is_number(n) do
    reply = {:ok, n}
    {:reply, reply, [n | stack]}
  end

  def handle_call({:push_token, :+}, _from, [a, b | stack]) do
    result = a + b
    reply = {:ok, result}
    {:reply, reply, [result | stack]}
  end

  def handle_call({:push_token, :-}, _from, [a, b | stack]) do
    result = b - a
    reply = {:ok, result}
    {:reply, reply, [result | stack]}
  end

  def handle_call({:push_token, :*}, _from, [a, b | stack]) do
    result = a * b
    reply = {:ok, result}
    {:reply, reply, [result | stack]}
  end

  def handle_call({:push_token, :/}, _from, [0 | _] = stack) do
    {:stop, :division_by_zero, {:error, :edivzero}, stack}
  end

  def handle_call({:push_token, :/}, _from, [a, b | stack]) do
    result = div(b, a)
    reply = {:ok, result}
    {:reply, reply, [result | stack]}
  end
end
