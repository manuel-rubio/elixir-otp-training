defmodule Cache.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Cache.Resource,
      Cache
    ]

    opts = [strategy: :one_for_one, name: Cache.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
