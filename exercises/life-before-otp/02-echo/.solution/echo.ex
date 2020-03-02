defmodule Echo do
  @moduledoc """
  Create a process that will send back the message to the sender
  """

  @doc """
  `start/0` should start an Echo server and return a `server_pid`

      iex> server_pid = Echo.start()
      iex> is_pid(server_pid)
      true
      iex> Process.alive?(server_pid)
      true

  """
  def start() do
    server_pid = spawn(__MODULE__, :init, [])
    server_pid
  end

  @doc """
  Bounce should take a `server_pid` and a `message`

  The server should send the message back to the calling process.

      iex> server_pid = Echo.start()
      iex> message = "Hello, World!"
      ...> Echo.bounce(server_pid, message)
      :ok
      ...> receive do
      ...>   ^message -> :ok
      ...> end
      :ok

  If you execute the code from an iex shell you can use the `flush`
  function to introspect the iex sessions mailbox instead of setting
  up the receive block as shown in the example.
  """
  def bounce(server_pid, msg) do
    send server_pid, {self(), msg}
    :ok
  end

  @doc """
  `stop/0` should stop an Echo server and return `:ok` when done

      iex> server_pid = Echo.start()
      iex> Echo.stop(server_pid)
      :ok
      iex> Process.alive?(server_pid)
      false

  """
  def stop(server_pid) do
    send server_pid, {:stop, self()}
    # If we don't set up the receive it will make the concurrent tests
    # flakey, as they check if the pid is still alive after we send
    # the stop command; if we don't block we will introduce a race
    # condition
    receive do
      :stopped ->
        :ok
    end
  end

  @doc false
  def init() do
    loop()
  end

  defp loop() do
    receive do
      {:stop, caller_pid} ->
        send caller_pid, :stopped
        nil

      {caller_pid, message} ->
        send caller_pid, message
        loop()
    end
  end
end
