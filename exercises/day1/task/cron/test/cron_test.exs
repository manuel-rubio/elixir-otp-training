defmodule CronTest do
  use ExUnit.Case
  doctest Cron

  def run() do
    send(:test_cron, :hi)
  end

  test "empty cron starting and stopping" do
    assert {:ok, pid} = Cron.start_link([])
    assert Process.alive?(pid)
    assert :ok = Cron.stop()
    :ok
  end

  test "cron starting with one task" do
    assert Process.register(self(), :test_cron)
    assert {:ok, pid} = Cron.start_link([__MODULE__])
    assert Process.alive?(pid)
    assert_receive :hi, 2_000
    assert :ok = Cron.stop()
    assert Process.unregister(:test_cron)
    refute_receive _, 200
    :ok
  end

  test "cron starting with five task" do
    assert Process.register(self(), :test_cron)
    assert {:ok, pid} = Cron.start_link(List.duplicate(__MODULE__, 5))
    assert Process.alive?(pid)

    Enum.each(1..5, fn _ ->
      assert_receive :hi, 2_000
    end)

    assert :ok = Cron.stop()
    assert Process.unregister(:test_cron)
    refute_receive _, 200
    :ok
  end
end
