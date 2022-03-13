defmodule HackerNewsAggregator.Task.FetchTopStories do
  @doc """
  Module reponsible to fetch top stories from hacker news Api
  """

  use GenServer

  alias HackerNewsAggregator.Core.{StoryStorage, PubSub}
  alias HackerNewsAggregator.HackerNews.Api

  @fetch_interval_time_in_seconds Application.get_env(
                                    :ex_hacker_news_aggregator,
                                    :fetch_interval_time,
                                    300
                                  )

  @doc false
  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  @doc false
  def start_link(opts) do
    task_name = Access.get(opts, :name, __MODULE__)
    storage_name = Access.get(opts, :storage, StoryStorage)
    pubsub_name = Access.get(opts, :pubsub, PubSub)

    state =
      Map.new()
      |> Map.put_new(:name, task_name)
      |> Map.put_new(:storage, storage_name)
      |> Map.put_new(:pubsub, pubsub_name)

    GenServer.start_link(__MODULE__, state, name: task_name)
  end

  @impl true
  @doc false
  def init(%{storage: storage, pubsub: pubsub} = state) do
    push_top_stories(storage, pubsub)
    :timer.send_interval(:timer.seconds(@fetch_interval_time_in_seconds), :fetch)

    {:ok, state}
  end

  @impl true
  @doc false
  def handle_info(:fetch, %{storage: storage, pubsub: pubsub} = state) do
    push_top_stories(storage, pubsub)

    {:noreply, state}
  end

  defp push_top_stories(storage, pubsub) do
    {:ok, top_stories} = Api.top_stories()
    StoryStorage.put_top_stories(storage, top_stories)

    PubSub.broadcast(pubsub, top_stories)
  end
end
