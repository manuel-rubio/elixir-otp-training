defmodule KeyValue.Application do
  use Application

  @dynsup KeyValue.DynSup

  @doc """
  This functions needs to start a Supervisor which has a dynamic supervisor
  inside defined (we provide the name of that supervisor via `@dynsup`).
  """
  def start(_type, _args) do
    :noimpl
  end

  @doc """
  Start a child inside of the dynamic supervisor. It should return `{:ok, pid}`
  if everything was right. Hint: DynamicSupervisor.start_child/2.
  """
  def start_child() do
    :noimpl
  end

  @doc """
  Stop/Terminate a child from the dynamic supervisor given the PID for the child.
  This should return `:ok`. Hint: DynamicSupervisor.terminate_child/2.
  """
  def stop_child(pid) do
    :noimpl
  end

  @doc """
  Return the children started inside of the dynamic supervisor.
  Hint: DynamicSupervisor.which_children/1.
  """
  def children() do
    :noimpl
  end

  @doc """
  Given a position inside of the list of children, we should to retrieve the child
  on that position.
  """
  def get_pid(i) do
    :noimpl
  end
end
