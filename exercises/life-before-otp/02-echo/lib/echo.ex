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
    raise "Implement me"
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
    raise "Implement me"
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
    raise "Implement me"
  end
end
