defmodule Mutex do
  @moduledoc """
  Write a process that will act as a binary semaphore providing mutual
  exclusion (mutex) for processes that want to share a resource. Model
  your process as a finite state machine with two states, busy and
  free. If a process tries to take the mutex (by calling
  `Mutex.wait()`) when the process is in state busy, the function call
  should hang until the mutex becomes available (namely, the process
  holding the mutex calls `Mutex.signal()`).
  """

  def start() do
    spawn(__MODULE__, :init, [])
  end

  def wait(pid, timeout \\ 5000) do
    send pid, {:wait, self()}
    receive do
      {:reply, {:ok, ref}} ->
        {:ok, ref}

      {:reply, {:error, _reason} = error} ->
        error

    after timeout ->
        {:error, :timeout}
    end
  end

  def signal(pid, reference, timeout \\ 5000) do
    send pid, {:signal, {self(), reference}}
    receive do
      {:reply, :ok} ->
        :ok

      {:reply, {:error, _reason} = error} ->
        error

    after timeout ->
        {:error, :timeout}
    end
  end

  def init() do
    free()
  end

  def free() do
    receive do
      {:wait, pid} ->
        reference = make_ref()
        send pid, {:reply, {:ok, reference}}
        busy({pid, reference})

      {:signal, {pid, _ref}} ->
        send pid, {:reply, {:error, :unexpected_caller}}
        free()
    end
  end

  def busy({pid, reference} = state) do
    receive do
      {:signal, {^pid, ^reference}} ->
        send pid, {:reply, :ok}
        free()

      {:signal, {other_pid, ^reference}} ->
        send other_pid, {:reply, {:error, :unexpected_caller}}
        busy(state)
    end
  end
end
