defmodule Syslog.Server do
  use GenStage

  @impl GenStage
  def init([port]) do
    {:ok, socket} = :gen_udp.open(port, active: true)
    {:producer, socket, dispatcher: GenStage.BroadcastDispatcher}
  end

  @impl GenStage
  def handle_info({:udp, _socket, ip, port, packet}, state) do
    IO.ANSI.format([
      :inverse,
      "RECV",
      :blue,
      " #{inspect(ip)}",
      :green,
      " #{port}",
      :reset,
      "\n",
      packet
    ])
    |> IO.puts()

    {:noreply, [packet], state}
  end

  @impl GenStage
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  @impl GenStage
  def terminate(_reason, socket) do
    :gen_udp.close(socket)
  end
end
