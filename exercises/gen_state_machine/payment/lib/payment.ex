defmodule Payment do
  use GenStateMachine,
    callback_mode: [
      :handle_event_function,
      :state_enter
    ]

  @timeout_each_step 10_000

  def start(), do: GenStateMachine.start(__MODULE__, [])
  def stop(pid), do: GenStateMachine.stop(pid)
  def get_order(pid), do: GenStateMachine.call(pid, :get_order)
  def set_creds(pid, name), do: GenStateMachine.cast(pid, {:set_creds, name})
  def choose(pid, type), do: GenStateMachine.cast(pid, {:choose, type})
  def provide_card(pid, card), do: GenStateMachine.cast(pid, {:provide_card, card})
  def provide_account(pid, account), do: GenStateMachine.cast(pid, {:provide_account, account})

  defmodule Data do
    defstruct name: nil,
              method: nil,
              card: nil,
              account: nil
  end

  @impl GenStateMachine
  def init([]) do
    {:error, :noimpl}
  end

  ## All events

  @impl GenStateMachine
  def handle_event(_type, _content, _state_name, _state_data) do
    {:error, :noimpl}
  end
end
