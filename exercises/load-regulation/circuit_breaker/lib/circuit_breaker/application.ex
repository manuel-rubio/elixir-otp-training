defmodule CircuitBreaker.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {CircuitBreaker.LimitedResource, [name: CircuitBreaker.LimitedResource]}
    ]

    install_fuse()

    opts = [strategy: :one_for_one, name: CircuitBreaker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp install_fuse() do
    name = :limited_resource
    # allow two melts within a window of 60 seconds
    strategy = {:standard, 2, 60}
    # reset after one minute when fust is blown
    refresh = {:reset, 60_000}
    opts = {strategy, refresh}
    :fuse.install(name, opts)
  end
end
