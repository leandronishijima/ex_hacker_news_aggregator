defmodule HackerNewsAggregator.HackerNews.ApiTest do
  use ExUnit.Case, async: true
  import Mox

  alias HackerNewsAggregator.HackerNews.ApiImpl

  setup :verify_on_exit!

  describe "top_stories/0" do
    test "when everything goes ok in api return" do
      HackerNewsAggregator.HackerNews.MockAPI
      |> expect(:top_stories, fn -> {:ok, [1, 2, 3]} end)

      assert {:ok, [1, 2, 3]} == ApiImpl.top_stories()
    end
  end
end
