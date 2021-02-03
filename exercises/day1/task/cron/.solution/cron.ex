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
    GenServer.start_link(__MODULE__, attached_modules, name: __MODULE__)
  end

  @doc """
  Stop the server.
  """
  def stop(), do: GenServer.stop(__MODULE__)

  @doc false
  @impl GenServer
  def init(attached_modules) do
    Process.send_after(self(), :run, @time_to_run)
    {:ok, attached_modules}
  end

  @doc false
  @impl GenServer
  def handle_info(:run, attached_modules) do
    Enum.each(attached_modules, fn module ->
      Task.start(module, :run, [])
    end)

    Process.send_after(self(), :run, @time_to_run)
    {:noreply, attached_modules}
  end
end
