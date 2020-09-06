defmodule PaymentTest do
  use ExUnit.Case

  describe "correct payments" do
    test "payment using a card" do
      assert {:ok, pid} = Payment.start()
      assert :ok = Payment.set_creds(pid, "Manuel")
      assert :ok = Payment.choose(pid, :card)
      assert :ok = Payment.provide_card(pid, "4242424242424242")

      assert %Payment.Data{
               card: "4242424242424242",
               method: :card,
               name: "Manuel"
             } = Payment.get_order(pid)

      assert {:paid, _} = :sys.get_state(pid)
    end

    test "payment using an account" do
      assert {:ok, pid} = Payment.start()
      assert :ok = Payment.set_creds(pid, "Manuel")
      assert :ok = Payment.choose(pid, :account)
      assert :ok = Payment.provide_account(pid, "1234")

      assert %Payment.Data{
               account: "1234",
               method: :account,
               name: "Manuel"
             } = Payment.get_order(pid)

      assert {:paid, _} = :sys.get_state(pid)
    end
  end

  describe "wrong payments" do
    test "providing account when expecting card" do
      assert {:ok, pid} = Payment.start()
      assert :ok = Payment.set_creds(pid, "Manuel")
      assert :ok = Payment.choose(pid, :card)
      assert :ok = Payment.provide_account(pid, "1234")

      assert %Payment.Data{
               account: nil,
               card: nil,
               method: :card,
               name: "Manuel"
             } = Payment.get_order(pid)

      assert {:pay_by_card, _} = :sys.get_state(pid)
    end

    test "providing card when expecting account" do
      assert {:ok, pid} = Payment.start()
      assert :ok = Payment.set_creds(pid, "Manuel")
      assert :ok = Payment.choose(pid, :account)
      assert :ok = Payment.provide_card(pid, "4242424242424242")

      assert %Payment.Data{
               account: nil,
               card: nil,
               method: :account,
               name: "Manuel"
             } = Payment.get_order(pid)

      assert {:pay_by_account, _} = :sys.get_state(pid)
    end
  end
end
