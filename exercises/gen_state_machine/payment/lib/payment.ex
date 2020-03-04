defmodule Payment do
  use GenStateMachine, callback_mode: [
    :handle_event_function,
    :state_enter
  ]

  @timeout_each_step 10_000

  def start(), do: GenStateMachine.start(__MODULE__, [])
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
    {:ok, :credentials, %Data{}}
  end

  @impl GenStateMachine
  def handle_event({:call, from}, :get_order, _state_name, data) do
    actions = [{:reply, from, data}]
    {:keep_state_and_data, actions}
  end

  def handle_event(:cast, {:set_creds, name}, :credentials, data) do
    {:next_state, :method_of_payment, %Data{data | name: name}}
  end

  def handle_event(:cast, {:choose, :card}, :method_of_payment, data) do
    {:next_state, :pay_by_card, %Data{data | method: :card}}
  end

  def handle_event(:cast, {:choose, :account}, :method_of_payment, data) do
    {:next_state, :pay_by_account, %Data{data | method: :account}}
  end

  def handle_event(:cast, {:provide_card, card}, :pay_by_card, data) do
    {:next_state, :paid, %Data{data | card: card}}
  end

  def handle_event(:cast, {:provide_account, account}, :pay_by_account, data) do
    {:next_state, :paid, %Data{data | account: account}}
  end

  def handle_event(:enter, old, :paid, _data) when old in [:pay_by_card, :pay_by_account] do
    IO.puts("Paid!")
    :keep_state_and_data
  end
  def handle_event(:enter, _old, _new, _data) do
    actions = [{:state_timeout, @timeout_each_step, :go_away}]
    {:keep_state_and_data, actions}
  end

  def handle_event(:state_timeout, :go_away, _state, _data) do
    IO.puts "Time is over!"
    {:stop, :normal}
  end

  def handle_event(_type, _content, _state_name, _state_data) do
    :keep_state_and_data
  end
end
