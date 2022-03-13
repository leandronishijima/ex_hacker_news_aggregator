defmodule HackerNewsAggregator.Task.FetchTopStoriesTest do
  use ExUnit.Case

  import Mox

  alias HackerNewsAggregator.Task.FetchTopStories
  alias HackerNewsAggregator.Core.{StoryStorage, PubSub}

  setup do
    {:ok, storage} = StoryStorage.start_link(name: :story_storage_fetch_test)
    {:ok, pubsub} = PubSub.start_link(name: :pubsub_fetch_test)

    %{storage: storage, pubsub: pubsub}
  end

  setup [:set_mox_global, :verify_on_exit!]

  test "fetch top stories on init/1", %{storage: storage, pubsub: pubsub} do
    HackerNewsAggregator.HackerNews.MockApi
    |> expect(:top_stories, fn ->
      {:ok,
       [
         30_582_202,
         30_580_444,
         30_566_119,
         30_582_986,
         30_579_884,
         30_582_877,
         30_581_735,
         30_578_938,
         30_583_059,
         30_566_741
       ]}
    end)

    {:ok, _} = FetchTopStories.start_link(name: __MODULE__, storage: storage, pubsub: pubsub)

    assert [
             30_582_202,
             30_580_444,
             30_566_119,
             30_582_986,
             30_579_884,
             30_582_877,
             30_581_735,
             30_578_938,
             30_583_059,
             30_566_741
           ] ==
             StoryStorage.get_top_stories(storage)
  end

  @tag :skip
  test "handle_info/2 fetch top stories before configured time", %{
    storage: storage,
    pubsub: pubsub
  } do
    HackerNewsAggregator.HackerNews.MockApi
    |> expect(:top_stories, 3, fn ->
      {:ok, [1, 2, 3]}
    end)

    {:ok, _} = FetchTopStories.start_link(name: __MODULE__, storage: storage, pubsub: pubsub)
    refute_received :fetch

    assert_receive :fetch, 3000
  end
end
