defmodule KeyValue.Application do
  use Application

  @dynsup KeyValue.DynSup

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, [strategy: :one_for_one, name: @dynsup]},
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: KeyValue.Supervisor)
  end

  def start_child() do
    DynamicSupervisor.start_child(@dynsup, {KeyValue, []})
  end

  def children() do
    DynamicSupervisor.which_children(@dynsup)
  end

  def get_pid(i) do
    children()
    |> Enum.at(i)
    |> elem(1)
  end
end
