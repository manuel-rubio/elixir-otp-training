defmodule Prime.Producer do
  use GenStage

  @impl GenStage
  def init([]) do
    {:producer, _first_prime_number = 1, dispatcher: GenStage.DemandDispatcher}
  end

  @impl GenStage
  def handle_demand(demand, prime_number) do
    {numbers, new_prime_number} = Enum.map_reduce(1..demand, prime_number, &get_prime/2)
    print_numbers = Enum.join(numbers, ", ")

    IO.ANSI.format([:inverse, " -- PRODUCING -- ", :reset, "\n", print_numbers])
    |> IO.puts()

    {:noreply, numbers, new_prime_number}
  end

  defp get_prime(_, prime_number) do
    new_prime_number = find_prime(prime_number + 1)
    {prime_number, new_prime_number}
  end

  defp find_prime(i) do
    m = trunc(:math.sqrt(i))

    cond do
      i >= 1 and i <= 3 -> i
      Enum.all?(2..m, &(rem(i, &1) != 0)) -> i
      true -> find_prime(i + 1)
    end
  end
end
