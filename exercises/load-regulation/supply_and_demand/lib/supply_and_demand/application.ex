defmodule SupplyAndDemand.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {SupplyAndDemand.Producer, 0},
      {SupplyAndDemand.ConsumerProducer, []},
      SupplyAndDemand.Consumer
    ]

    opts = [strategy: :one_for_one, name: SupplyAndDemand.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
