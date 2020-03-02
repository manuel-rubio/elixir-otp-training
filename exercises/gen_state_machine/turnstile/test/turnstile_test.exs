defmodule TurnstileTest do
  use ExUnit.Case
  doctest Turnstile

  def start_turnstile(context) do
    {:ok, pid} = Turnstile.start([])
    {:ok, Map.put(context, :turnstile, pid)}
  end

  describe "life-cycle" do
    test "start-stop" do
      assert {:ok, pid} = Turnstile.start([])
      assert :ok = Turnstile.stop(pid)
    end
  end

  describe "operation" do
    setup [:start_turnstile]

    @tag skip: true
    test "insert token", %{turnstile: pid} do
      assert :ok = Turnstile.insert_token(pid)
    end

    @tag skip: true
    test "insert token and enter", %{turnstile: pid} do
      :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.enter(pid)
    end

    @tag skip: true
    test "attempt to enter while locked", %{turnstile: pid} do
      assert {:error, :access_denied} = Turnstile.enter(pid)
    end

    @tag skip: true
    test "should lock when person enters", %{turnstile: pid} do
      :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.enter(pid)
      assert {:error, :access_denied} = Turnstile.enter(pid)
    end

    @tag skip: true
    test "inserting tokens while unlocked should just consume the token", %{turnstile: pid} do
      :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.enter(pid)
      assert {:error, :access_denied} = Turnstile.enter(pid)
    end
  end

  describe "cancel" do
    setup [:start_turnstile]

    @tag skip: true
    test "cancel while in locked state", %{turnstile: pid} do
      assert :ok = Turnstile.cancel(pid)
      assert {:locked, _} = :sys.get_state(pid)
    end

    @tag skip: true
    test "cancel while in unlocked state", %{turnstile: pid} do
      assert :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.cancel(pid)
      assert {:locked, _} = :sys.get_state(pid)
    end

    @tag skip: true
    test "getting from an empty coin return should yield nothing", %{turnstile: pid} do
      assert {:ok, []} = Turnstile.empty_coin_return(pid)
    end

    @tag skip: true
    test "emptying the coin return after inserting and canceling should yield a token", %{
      turnstile: pid
    } do
      assert :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.cancel(pid)
      # Inserting a token and canceling should result in one token in
      # the coin return:
      assert {:ok, [_]} = Turnstile.empty_coin_return(pid)
    end

    @tag skip: true
    test "ensure the coin return is empty after emptying", %{
      turnstile: pid
    } do
      assert :ok = Turnstile.insert_token(pid)
      assert :ok = Turnstile.cancel(pid)
      # After inserting and canceling we should have one token in the
      # coin return:
      assert {:ok, [_]} = Turnstile.empty_coin_return(pid)
      # After emptying the coin return should be empty
      assert {:ok, []} = Turnstile.empty_coin_return(pid)
    end

    @tag skip: true
    test "inserting two coins and canceling should result in two coins in coin return", %{
      turnstile: pid
    } do
      assert [:ok, :ok] = [Turnstile.insert_token(pid), Turnstile.insert_token(pid)]
      assert :ok = Turnstile.cancel(pid)
      # After inserting twice and canceling we should have two tokens
      # in the coin return:
      assert {:ok, [_, _]} = Turnstile.empty_coin_return(pid)
      # After emptying the coin return should be empty
      assert {:ok, []} = Turnstile.empty_coin_return(pid)
    end
  end

  describe "handling coins" do
    setup [:start_turnstile]

    @tag skip: true
    test "should not return if the user pays the exact amount", %{turnstile: pid} do
      # the default turnstile has a cost of entry set to 1
      assert :ok = Turnstile.insert_token(pid, {:coin, 1})
      assert {:ok, []} = Turnstile.empty_coin_return(pid)
      assert :ok = Turnstile.enter(pid)
    end

    @tag skip: true
    test "should return money if the user pays too much", %{turnstile: pid} do
      # the default turnstile has a cost of entry set to 1
      assert :ok = Turnstile.insert_token(pid, {:coin, 5})
      assert {:ok, [{:coin, 4}]} = Turnstile.empty_coin_return(pid)
      assert :ok = Turnstile.enter(pid)
    end

    @tag skip: true
    test "should remain locked until the entry price has been reached" do
      {:ok, pid} = Turnstile.start(entry_price: 2)
      :ok = Turnstile.insert_token(pid, {:coin, 1})
      assert {:error, :access_denied} = Turnstile.enter(pid)
      :ok = Turnstile.insert_token(pid, {:coin, 1})
      assert :ok = Turnstile.enter(pid)
    end

    @tag skip: true
    test "should return the inserted coins if the user press cancel" do
      {:ok, pid} = Turnstile.start(entry_price: 7)
      :ok = Turnstile.insert_token(pid, {:coin, 2})
      :ok = Turnstile.insert_token(pid, {:coin, 3})
      :ok = Turnstile.insert_token(pid, {:coin, 1})

      :ok = Turnstile.cancel(pid)
      assert {:ok, [{:coin, 1}, {:coin, 3}, {:coin, 2}]} = Turnstile.empty_coin_return(pid)
    end

    @tag skip: true
    test "coins inserted when unlocked should go to the coin return" do
      {:ok, pid} = Turnstile.start(entry_price: 1)
      :ok = Turnstile.insert_token(pid, {:coin, 1})
      :ok = Turnstile.insert_token(pid, {:coin, 2})
      :ok = Turnstile.insert_token(pid, {:coin, 3})
      assert {:ok, [{:coin, 3}, {:coin, 2}]} = Turnstile.empty_coin_return(pid)
      assert :ok = Turnstile.enter(pid)
    end

    @tag skip: true
    test "the payed amount should be returned if user enter exact amount and cancel" do
      {:ok, pid} = Turnstile.start(entry_price: 6)
      :ok = Turnstile.insert_token(pid, {:coin, 1})
      :ok = Turnstile.insert_token(pid, {:coin, 2})
      :ok = Turnstile.insert_token(pid, {:coin, 3})
      assert :ok = Turnstile.cancel(pid)
      assert {:ok, [{:coin, 3}, {:coin, 2}, {:coin, 1}]} = Turnstile.empty_coin_return(pid)
    end
  end

  describe "timeout" do
    @tag skip: true
    test "should reset to locked if the turnstile is unlocked for too long" do
      {:ok, pid} = Turnstile.start(entry_price: 1, unlock_timeout: 0)
      :ok = Turnstile.insert_token(pid, {:coin, 1})
      # Because the timeout will trigger instantly the state should be locked
      assert {:locked, _} = :sys.get_state(pid)
      # The coin we inserted should be in the coin return
      assert {:ok, [{:coin, 1}]} = Turnstile.empty_coin_return(pid)
    end
  end
end
