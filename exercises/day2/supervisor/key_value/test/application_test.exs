defmodule KeyValue.ApplicationTest do
  use ExUnit.Case, async: false

  test "lifecycle" do
    assert {:ok, [:key_value]} = Application.ensure_all_started(:key_value)
    assert :ok = Application.stop(:key_value)
    assert :ok = Application.unload(:key_value)
  end

  describe "retrieving dynamic supervisor information" do
    setup do
      Application.ensure_all_started(:key_value)
      :ok

      on_exit(:teardown, fn ->
        Application.stop(:key_value)
        Application.unload(:key_value)
      end)
    end

    test "start/stop a new child" do
      assert {:ok, pid} = KeyValue.Application.start_child()
      assert Process.alive?(pid)
      ref = Process.monitor(pid)
      assert :ok = KeyValue.Application.stop_child(pid)
      assert_receive {:DOWN, ^ref, :process, ^pid, :shutdown}
    end

    test "get children and specific child" do
      [pid | _] =
        children =
        for _ <- 1..10 do
          {:ok, pid} = KeyValue.Application.start_child()
          pid
        end

      assert Enum.all?(children, &Process.alive?/1)
      assert [{_, ^pid, _, _} | _] = children_sup = KeyValue.Application.children()
      assert 10 = length(children_sup)
      assert ^pid = KeyValue.Application.get_pid(0)

      for pid <- children do
        assert :ok = KeyValue.Application.stop_child(pid)
      end

      :ok
    end
  end
end
