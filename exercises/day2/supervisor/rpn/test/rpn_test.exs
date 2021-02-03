defmodule RpnTest do
  use ExUnit.Case
  doctest Rpn

  defp start_rpc(context) do
    {:ok, pid} = Rpn.start_link()
    Map.put(context, :rpc_pid, pid)
  end

  test "life-cycle" do
    assert {:ok, pid} = Rpn.start_link()
    assert is_pid(pid)
    assert Process.alive?(pid)
    assert :ok = Rpn.stop(pid)
    refute Process.alive?(pid)
  end

  describe "pushing tokens" do
    setup :start_rpc

    test "addition", %{rpc_pid: pid} do
      {:ok, 5} = Rpn.push(pid, 5)
      {:ok, 7} = Rpn.push(pid, 7)
      assert {:ok, 12} = Rpn.push(pid, :+)
    end

    test "subtraction", %{rpc_pid: pid} do
      {:ok, 7} = Rpn.push(pid, 7)
      {:ok, 5} = Rpn.push(pid, 5)
      assert {:ok, 2} = Rpn.push(pid, :-)
    end

    test "multiplication", %{rpc_pid: pid} do
      {:ok, 5} = Rpn.push(pid, 5)
      {:ok, 50} = Rpn.push(pid, 50)
      assert {:ok, 250} = Rpn.push(pid, :*)
    end

    test "division", %{rpc_pid: pid} do
      {:ok, 50} = Rpn.push(pid, 50)
      {:ok, 5} = Rpn.push(pid, 5)
      assert {:ok, 10} = Rpn.push(pid, :/)
    end

    test "centigrades to farenheit (40ºC -> 104ºF)", %{rpc_pid: pid} do
      {:ok, 9} = Rpn.push(pid, 9)
      {:ok, 40} = Rpn.push(pid, 40)
      {:ok, 360} = Rpn.push(pid, :*)
      {:ok, 5} = Rpn.push(pid, 5)
      {:ok, 72} = Rpn.push(pid, :/)
      {:ok, 32} = Rpn.push(pid, 32)
      assert {:ok, 104} = Rpn.push(pid, :+)
    end

    test "broken division", %{rpc_pid: pid} do
      Process.monitor(pid)
      Process.unlink(pid)
      {:ok, 1} = Rpn.push(pid, 1)
      {:ok, 0} = Rpn.push(pid, 0)
      assert {:error, :edivzero} = Rpn.push(pid, :/)
      assert_receive {:DOWN, _ref, :process, _pid, :division_by_zero}
    end
  end
end
