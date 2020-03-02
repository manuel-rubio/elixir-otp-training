defmodule EchoTest do
  use ExUnit.Case
  doctest Echo

  # There are doc tests in the Echo module, you can activate these by
  # removing the :skip tags, but as such the doctests found in the
  # `Echo` module should be sufficient

  @tag :skip
  test "Life-cycle" do
    assert pid = Echo.start()
    assert is_pid(pid)
    assert Process.alive?(pid)
    assert :ok = Echo.stop(pid)
    refute Process.alive?(pid)
  end

  @tag :skip
  describe "Sending a message" do
    test "Should echo the message back to the sender" do
      pid = Echo.start()
      assert :ok = Echo.bounce(pid, :msg)
      assert_receive :msg
    end
  end
end
