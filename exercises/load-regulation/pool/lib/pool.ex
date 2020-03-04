defmodule Pool do
  def start() do
    pool_args = [
      name: {:local, __MODULE__},
      worker_module: Resource,
      size: 2,
      max_overflow: 5
    ]
    worker_args = []
    :poolboy.start(pool_args, worker_args)
  end
end
