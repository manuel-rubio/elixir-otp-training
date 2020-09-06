defmodule FrequencyTest do
  use ExUnit.Case

  @moduledoc """
  WARNING: Don't make those kind of tests at home!

  This is intended to be an integration test, but there is
  too much hardcoded data inside. The best approach is use
  IoC (Inversion of Control) and inject data which could be
  controlled from the test.

  Anyway, the data we are using is hardcoded as well inside
  of the code so, nevermind.
  """

  describe "Frequency tests" do
    setup do
      Frequency.start()

      on_exit(:stop_frequency, fn ->
        :stop = Frequency.stop()
      end)

      :ok
    end

    @doc """
    The test allocation is retrieving all of the known frequencies
    from the system. We know we have a list from 10 to 15 and then
    we are run out of frequencies.
    """
    test "Test allocation" do
      for i <- 10..15 do
        assert {:ok, i} == Frequency.allocate()
      end

      assert {:error, _} = Frequency.allocate()
      :ok
    end

    @doc """
    Test deallocation can insert new values inside of the state data
    we take advantage of that and insert 5 elments which are after that
    retrieved using the allocate function. The last element retrieved
    is the original one so, that means it worked.
    """
    test "Test deallocation" do
      for i <- 1..5 do
        assert :ok == Frequency.deallocate(i)
      end

      for i <- 5..1 do
        assert {:ok, i} == Frequency.allocate()
      end

      assert {:ok, 10} = Frequency.allocate()
      :ok
    end

    @doc """
    Retrieve a list of frequencies. The list is the whole list
    from 10 to 15 which should be _hardcoded_ inside of the
    Frequencies module.
    """
    test "List available frequencies" do
      assert [10, 11, 12, 13, 14, 15] == Frequency.list_available()
      :ok
    end

    @doc """
    Retrieve the allocated frequencies. This list should give us
    the list of the allocated items. To ensure this is working we
    allocate only one item. Then two and receive the list.
    """
    test "List allocated frequencies" do
      pid = self()
      assert [] == Frequency.list_allocated()
      assert {:ok, 10} = Frequency.allocate()
      assert [{10, ^pid}] = Frequency.list_allocated()
      assert {:ok, 11} = Frequency.allocate()
      assert [{11, ^pid}, {10, ^pid}] = Frequency.list_allocated()
      :ok
    end
  end
end
