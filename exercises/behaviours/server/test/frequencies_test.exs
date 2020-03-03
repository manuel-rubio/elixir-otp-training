defmodule FrequencyTest do
  use ExUnit.Case

  ## WARNING: Don't make those kind of tests at home!

  describe "Frequency tests" do
    test "Test allocation" do
      Frequency.start()
      for i <- 10..15 do
        assert {:ok, i} == Frequency.allocate()
      end
      assert {:error, _} = Frequency.allocate()
      assert :stop = Frequency.stop()
      :ok
    end

    test "Test deallocation" do
      Frequency.start()
      for i <- 1..5 do
        assert :ok == Frequency.deallocate(i)
      end
      for i <- 5..1 do
        assert {:ok, i} == Frequency.allocate()
      end
      assert {:ok, 10} = Frequency.allocate()
      assert :stop = Frequency.stop()
      :ok
    end

    test "List available frequencies" do
      Frequency.start()
      assert [10, 11, 12, 13, 14, 15] == Frequency.list_available()
      assert :stop = Frequency.stop()
      :ok
    end

    test "List allocated frequencies" do
      Frequency.start()
      assert [] == Frequency.list_allocated()
      assert {:ok, 10} = Frequency.allocate()
      assert [{10, _pid}] = Frequency.list_allocated()
      assert :stop = Frequency.stop()
      :ok
    end
  end
end
