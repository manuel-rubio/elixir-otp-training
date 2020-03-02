defmodule CircuitBreaker do
  @moduledoc """
  Protect a limited resource with a Fuse/Circuit Breaker. When we
  access the limited resource we will ask a fuse (that is installed
  when the Application is started) if the limited resourse is
  available:

  - If it is we will access it directly
  - If the limited resource return an error we will melt the fuse
  - When the fuse is melted enough we it will blow, and future
    requests will get blocked at the fuse until it reset

  Try executing the `request_limited_resource` function in an iex
  session. When the code is run enough the fuse will break and you
  will be able to see it heal again when the reset timeout is reached.

  See the fuse configuration in `CircuitBreaker.Application`, and try
  to play around with its settings.
  """

  @doc """
  Meant to be run from an iex session

  Observe its behaviour when run many times in a row.
  """
  def request_limited_resource() do
    with {:fuse, :ok} <- {:fuse, :fuse.ask(:limited_resource, :sync)},
         {:request, :ok} <- {:request, CircuitBreaker.LimitedResource.request()} do
      "Went through to the limited resource"
    else
      {:fuse, :blown} ->
        "Fuse blown; Stopped at the the broken fuse"

      {:request, {:error, :overloaded}} ->
        # melt the `:limited_resource` fuse
        :fuse.melt(:limited_resource)
        "Limited resource responded with error: melting fuse a bit"
    end
  end
end
