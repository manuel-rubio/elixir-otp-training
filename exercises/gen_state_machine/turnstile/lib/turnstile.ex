defmodule Turnstile do
  @moduledoc """
  Documentation for Turnstile.
  """

  use GenStateMachine

  defstruct []

  # Client API
  @doc """
  Start a turnstile process
  """
  def start(opts) do
    GenStateMachine.start(__MODULE__, opts)
  end

  @doc """
  Stop a turnstile process
  """
  def stop(pid) do
    GenStateMachine.stop(pid)
  end

  @doc """
  Insert a coin into the turnstile process running on `pid`
  """
  def insert_token(_pid, {:coin, value} = coin \\ {:coin, 1}) when is_integer(value) do
    raise "Implement me"
  end

  @doc """
  Enter the turnstile running on ~pid~
  """
  def enter(_pid) do
    raise "Implement me"
  end

  @doc """
  Cancel the transaction with the current turnstile running on ~pid~
  """
  def cancel(_pid) do
    raise "Implement me"
  end

  # Server callbacks
  @impl GenStateMachine
  def init(opts) do
    initial_state = struct!(__MODULE__, opts)
    {:ok, :locked, initial_state}
  end
end
