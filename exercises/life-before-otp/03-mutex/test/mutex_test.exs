defmodule MutexTest do
  use ExUnit.Case
  doctest Mutex

  test "life-cycle" do
    assert pid = Mutex.start()
    assert is_pid(pid)

    test_process = self()

    child_pid = spawn_link(fn ->
      {:ok, ref} = Mutex.wait(pid)
      send test_process, :ready

      receive do
        :go ->
          Process.sleep(100)
          :ok = Mutex.signal(pid, ref)
          send test_process, :done

      after 500 ->
          raise "check your timeout"
      end
    end)

    assert_receive :ready
    send child_pid, :go

    {:ok, _ref} = Mutex.wait(pid)
    assert_receive :done
  end

  test "timeout" do
    pid = Mutex.start()
    assert {:error, :timeout} = Mutex.signal(pid, make_ref(), 0)
  end

  test "signal while free" do
    pid = Mutex.start()
    assert {:error, :unexpected_caller} = Mutex.signal(pid, make_ref())
  end
end
