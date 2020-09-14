defmodule KeyValueTest do
  use ExUnit.Case
  doctest KeyValue

  test "life-cycle: start-stop" do
    assert {:ok, pid} = KeyValue.start_link([])
    assert Process.alive?(pid)
    assert :ok = KeyValue.stop(pid)
    refute Process.alive?(pid)
  end
end
