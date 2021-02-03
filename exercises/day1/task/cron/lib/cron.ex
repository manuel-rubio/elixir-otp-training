defmodule Cron do
  @moduledoc """
  Cron is going to run a server with a timer to trigger an
  event to itself. When the timer happens, it's going to
  run the task attached from the start.

  To attach a task we have to provide the name of the
  module for the task. The function implemented for the
  task should be `run/0`.
  """
  use GenServer

  @time_to_run 1_000

  @doc """
  Start the server passing the attached module list.
  """
  def start_link(attached_modules) do
    # TODO
  end

  @doc """
  Stop the server.
  """
  def stop() do
    # TODO
  end

  @doc false
  @impl GenServer
  def init(attached_modules) do
    # TODO
  end

  @doc false
  @impl GenServer
  def handle_info(:run, attached_modules) do
    # TODO
  end
end
