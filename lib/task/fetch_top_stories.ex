defmodule HackerNewsAggregator.Task.FetchTopStories do
  use GenServer

  alias HackerNewsAggregator.Core.Registry, as: CoreRegistry
  alias HackerNewsAggregator.HackerNewsClient.ApiClient
  alias HackerNewsAggregator.Core.PubSub

  # @five_minutes_in_ms 300_000
  @five_minutes_in_ms 3_000

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
    push_top_stories()
    :timer.send_interval(@five_minutes_in_ms, :fetch)

    {:ok, state}
  end

  @impl true
  def handle_info(:fetch, state) do
    push_top_stories()

    {:noreply, state}
  end

  defp push_top_stories do
    {:ok, top_stories} = ApiClient.top_stories()
    CoreRegistry.put(CoreRegistry, "top_stories", top_stories)

    PubSub.broadcast(top_stories)
  end
end
