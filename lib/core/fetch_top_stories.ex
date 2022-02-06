defmodule HackerNewsAggregator.Core.FetchTopStories do
  use GenServer

  # @five_minutes_in_ms 300_000
  @five_minutes_in_ms 5_000

  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    scheduled_process()

    {:ok, state}
  end

  @impl true
  def handle_info(:fetch, state) do
    time =
      DateTime.utc_now()
      |> DateTime.to_time()
      |> Time.to_iso8601()

    IO.puts("The time is now: #{time}")

    scheduled_process()

    {:noreply, state}
  end

  defp scheduled_process do
    Process.send_after(self(), :fetch, @five_minutes_in_ms)
  end
end
