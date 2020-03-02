defmodule RpnTest do
  use ExUnit.Case
  doctest Rpn

  defp start_rpc(context) do
    {:ok, pid} = Rpn.start_link()
    Map.put(context, :rpc_pid, pid)
  end

  @tag skip: true
  test "life-cycle" do
    assert {:ok, pid} = Rpn.start_link()
    assert is_pid(pid)
    assert Process.alive?(pid)
    assert :ok = Rpn.stop(pid)
    refute Process.alive?(pid)
  end

  describe "pushing tokens" do
    setup :start_rpc

    @tag skip: true
    test "addition", %{rpc_pid: pid} do
      {:ok, 5} = Rpn.push(pid, 5)
      {:ok, 7} = Rpn.push(pid, 7)
      assert {:ok, 12} = Rpn.push(pid, :+)
    end

    @tag skip: true
    test "subtraction", %{rpc_pid: pid} do
      {:ok, 7} = Rpn.push(pid, 7)
      {:ok, 5} = Rpn.push(pid, 5)
      assert {:ok, 2} = Rpn.push(pid, :-)
    end

    @tag skip: true
    test "multiplication", %{rpc_pid: pid} do
      {:ok, 5} = Rpn.push(pid, 5)
      {:ok, 50} = Rpn.push(pid, 50)
      assert {:ok, 250} = Rpn.push(pid, :*)
    end

    @tag skip: true
    test "division", %{rpc_pid: pid} do
      {:ok, 50} = Rpn.push(pid, 50)
      {:ok, 5} = Rpn.push(pid, 5)
      assert {:ok, 10} = Rpn.push(pid, :/)
    end
  end
end
