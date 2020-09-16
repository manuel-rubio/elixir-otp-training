defmodule MutexTest do
  use ExUnit.Case
  doctest Mutex

  # @tag skip: true
  test "should start and stop" do
    {:ok, pid} = Mutex.start([])
    assert Process.alive?(pid)
    :ok = Mutex.stop(pid)
    refute Process.alive?(pid)
  end

  test "should block until mutex is free" do
    {:ok, pid} = Mutex.start([])
    parent = self()

    spawn_link(fn ->
      Mutex.await(pid)
      send parent, :ready
      Process.sleep(100)
      Mutex.signal(pid)
      send parent, :free
    end)

    assert_receive(:ready)
    assert :ok = Mutex.await(pid)
    assert_receive :free
  end

  test "the mutex should unblock clients in the order they arrived" do
    {:ok, pid} = Mutex.start([])
    parent = self()

    spawn_helper = fn (name) ->
      spawn_link(fn ->
        send parent, {:ready, name}
        assert :ok = Mutex.await(pid)
        send parent, {:got_the_lock, name}
        assert :ok = Mutex.signal(pid)
      end)
      assert_receive {:ready, ^name}
    end

    # First we take the lock ourselves
    assert :ok = Mutex.await(pid)
    # Then we spawn some helpers that should respond back in order
    spawn_helper.(:a)
    spawn_helper.(:b)
    spawn_helper.(:c)
    # free the lock such that the helpers will get unblocked
    assert :ok = Mutex.signal(pid)
    # We know the we messages in the mailbox will be taken out in the
    # order they arrived; so let's take them out of the mailbox and
    # assert on the order they arrived
    assert_receive {:got_the_lock, first}
    assert_receive {:got_the_lock, second}
    assert_receive {:got_the_lock, third}
    assert [:a, :b, :c] == [first, second, third]
  end

  test "should return an error to the client if the mutex is signaled while free" do
    {:ok, pid} = Mutex.start([])
    assert {:error, :unexpected_signal} = Mutex.signal(pid)
  end

  test "life-cycle" do
    assert {:ok, pid} = Mutex.start([])
    assert Process.alive?(pid)
    assert :ok = Mutex.await(pid)
    assert :ok = Mutex.signal(pid)
    assert :ok = Mutex.stop(pid)
    refute Process.alive?(pid)
  end
end
