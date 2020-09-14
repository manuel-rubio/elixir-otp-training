defmodule Rpn.Application do
  @moduledoc false
  use Application

  @doc """
  Start 3 Rpn servers. They have to be identified inside of the
  supervisor by their ID: rpn1, rpn2 and rpn3. Use the full
  specification.
  """
  def start(_type, _args) do
    children = [
      %{id: :rpn1, start: {Rpn, :start_link, []}},
      %{id: :rpn2, start: {Rpn, :start_link, []}},
      %{id: :rpn3, start: {Rpn, :start_link, []}}
    ]

    Supervisor.start_link(children, strategy: :one_for_all, name: Rpn.Supervisor)
  end
end
