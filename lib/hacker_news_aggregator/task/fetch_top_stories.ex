defmodule HackerNewsAggregator.Task.FetchTopStories do
  @moduledoc """
  Module reponsible to fetch top stories from hacker news Api
  """

  use GenServer

  require Logger

  alias HackerNewsAggregator.Core.{StoryStorage, PubSub}
  alias HackerNewsAggregator.HackerNews.Api

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
    schedule_send_interval()

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

    Logger.info("New top stories was refreshed")

    PubSub.broadcast(pubsub, top_stories)
  end

  defp schedule_send_interval do
    Application.get_env(
      :ex_hacker_news_aggregator,
      :fetch_interval_time,
      300
    )
    |> :timer.seconds()
    |> :timer.send_interval(:fetch)
  end
end
