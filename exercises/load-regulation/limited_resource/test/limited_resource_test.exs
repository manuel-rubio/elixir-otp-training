defmodule LimitedResourceTest do
  use ExUnit.Case

  @test_duration 20_000
  @processes 500
  @workload 100

  @tag timeout: :infinity
  test "Spawn within a safety valve regulated queue" do
    test_process_pid = self()

    for _x <- 1..@processes do
      worker = fn ->
        # block, simulate "work"
        Process.sleep(@workload)
      end

      spawn(fn ->
        # All the processes will start at the same time, so let's delay a bit
        # before starting the work; this will ensure the processes are evenly
        # distributed over the window we have set for the test
        Enum.random(0..(@test_duration - @workload)) |> Process.sleep()

        case :sv.run(:my_queue, worker) do
          {:ok, _res} ->
            send(test_process_pid, :success)

          {:error, reason} ->
            send(test_process_pid, {:rejected, reason})
        end
      end)
    end

    # Collect the results by entering a receive-loop that accumulate the
    # returned results of the workers
    collect_results(%{rejections: %{}}, @processes)
  end

  defp collect_results(acc, 0) do
    # format the results and print them to the standard output
    IO.write("\n\n")
    IO.inspect(acc, label: "Results")
  end

  defp collect_results(acc, remaining) do
    receive do
      :success ->
        IO.write(".")

        acc
        |> Map.update(:success, 1, &(1 + &1))
        |> collect_results(remaining - 1)

      {:rejected, reason} ->
        IO.write("x")

        acc
        |> update_in([:rejections, reason], &(1 + (&1 || 0)))
        |> collect_results(remaining - 1)
    after
      @test_duration ->
        # got bored, print results:
        collect_results(acc, 0)
    end
  end
end
