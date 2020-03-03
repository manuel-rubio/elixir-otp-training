defmodule Server do
  @moduledoc """
  Implementation of a Server
  """

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Server
      @impl Server
      def handle(_message, state) do
        {state, {:error, :no_implemented}}
      end

      defoverridable handle: 2

      # def child_spec([]) do
      #   %{
      #     id: __MODULE__,
      #     start: {__MODULE__, :start, []}
      #   }
      # end
    end
  end

  @callback init(module) :: term
  @callback handle(term, term) :: {term, term}

  def start(module, args) do
    pid = spawn(__MODULE__, :init, [module, args])
    Process.register(pid, module)
    {:ok, pid}
  end

  # def start_link(module, args) do
  #   pid = spawn_link(__MODULE__, :init, [module, args])
  #   Process.register(pid, module)
  #   {:ok, pid}
  # end

  def stop(pid), do: send(pid, :stop)

  def init(module, args) do
    state = apply(module, :init, [args])
    loop(module, state)
  end

  def loop(module, state) do
    receive do
      {:request, pid, message} ->
        {state, reply} = apply(module, :handle, [message, state])
        send(pid, {:reply, reply})
        loop(module, state)
      :stop -> :ok
    end
  end

  def call(pid, message) do
    send(pid, {:request, self(), message})
    receive do
      {:reply, reply} -> reply
    end
  end
end
