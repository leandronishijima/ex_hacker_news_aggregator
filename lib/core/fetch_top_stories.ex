defmodule HackerNewsAggregator.Core.FetchTopStories do
  use GenServer

  @five_minutes_in_ms 300_000

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
