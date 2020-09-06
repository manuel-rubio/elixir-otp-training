defmodule Syslog.Mail do
    use GenStage

    def start_link([producer]) do
      {:ok, pid} = GenStage.start_link(__MODULE__, [])
      GenStage.sync_subscribe(pid, to: producer, max_demand: 1, selector: &is_mail?/1)
      {:ok, pid}
    end
  
    @impl GenStage
    def init([]) do
      {:consumer, []}
    end
  
    @impl GenStage
    def handle_events([event], _from, state) do
      IO.ANSI.format([:inverse, "MAIL", :reset, "\n", event])
      |> IO.puts()
      {:noreply, [], state}
    end

    defp is_mail?([?<, a, b, ?>, ?1, 32 |_]) do
      div(List.to_integer([a, b]), 8) == 2
    end
    defp is_mail?(_data) do
      false
    end
  end
  