defmodule Turnstile do
  @moduledoc """
  Documentation for Turnstile.
  """

  use GenStateMachine

  defstruct coin_return: [], payment: [], entry_price: 1, unlock_timeout: 5_000

  def start(opts) do
    GenStateMachine.start(__MODULE__, opts)
  end

  def stop(pid), do: GenStateMachine.stop(pid)

  def insert_token(pid, {:coin, value} = coin \\ {:coin, 1}) when is_integer(value) do
    GenStateMachine.cast(pid, {:insert_token, coin})
  end

  def enter(pid) do
    GenStateMachine.call(pid, :enter)
  end

  def cancel(pid) do
    GenStateMachine.cast(pid, :cancel)
  end

  def empty_coin_return(pid) do
    GenStateMachine.call(pid, :empty_coin_return)
  end

  def init(opts) do
    initial_state = struct!(__MODULE__, opts)
    {:ok, :locked, initial_state}
  end

  # Locked
  def handle_event(:cast, {:insert_token, coin}, :locked, loop_data) do
    payment = [coin | loop_data.payment]
    total = Enum.reduce(payment, 0, fn {:coin, value}, acc -> value + acc end)

    cond do
      total == loop_data.entry_price ->
        loop_data = %__MODULE__{loop_data | payment: payment}
        next_actions = [{:state_timeout, loop_data.unlock_timeout, :idle}]
        {:next_state, :unlocked, loop_data, next_actions}

      total > loop_data.entry_price ->
        return = {:coin, total - loop_data.entry_price}
        coin_return = [return | loop_data.coin_return]
        loop_data = %__MODULE__{loop_data | payment: [], coin_return: coin_return}
        next_actions = [{:state_timeout, loop_data.unlock_timeout, :idle}]
        {:next_state, :unlocked, loop_data, next_actions}

      total < loop_data.entry_price ->
        {:keep_state, %__MODULE__{loop_data | payment: payment}}
    end
  end

  def handle_event({:call, from}, :enter, :locked, _loop_data) do
    next_actions = [{:reply, from, {:error, :access_denied}}]
    {:keep_state_and_data, next_actions}
  end

  def handle_event(:cast, :cancel, :locked, loop_data) do
    new_loop_data = %__MODULE__{
      loop_data
      | payment: [],
        coin_return: loop_data.payment ++ loop_data.coin_return
    }

    {:keep_state, new_loop_data}
  end

  # Unlocked
  def handle_event({:call, from}, :enter, :unlocked, loop_data) do
    next_actions = [{:reply, from, :ok}]
    {:next_state, :locked, loop_data, next_actions}
  end

  def handle_event(
        :cast,
        {:insert_token, {:coin, _value} = coin},
        :unlocked,
        %__MODULE__{coin_return: coin_return} = loop_data
      ) do
    new_loop_data = %__MODULE__{
      loop_data
      | coin_return: [coin | coin_return]
    }

    {:keep_state, new_loop_data}
  end

  def handle_event(
        :cast,
        :cancel,
        :unlocked,
        %__MODULE__{coin_return: coin_return, payment: payment} = loop_data
      ) do
    new_loop_data = %__MODULE__{
      loop_data
      | coin_return: payment ++ coin_return,
        payment: []
    }

    {:next_state, :locked, new_loop_data}
  end

  # Empty coin return
  def handle_event(
        {:call, from},
        :empty_coin_return,
        _current_state,
        %__MODULE__{coin_return: coin_return} = loop_data
      ) do
    next_actions = [{:reply, from, {:ok, coin_return}}]
    new_loop_data = %__MODULE__{loop_data | coin_return: []}
    {:keep_state, new_loop_data, next_actions}
  end

  # Timeouts
  def handle_event(
        :state_timeout,
        :idle,
        :unlocked,
        %__MODULE__{payment: payment, coin_return: coin_return} = loop_data
      ) do
    new_loop_data = %__MODULE__{
      loop_data
      | payment: [],
        coin_return: payment ++ coin_return
    }

    {:next_state, :locked, new_loop_data}
  end
end
