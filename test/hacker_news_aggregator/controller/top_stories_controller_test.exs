defmodule HackerNewsAggregator.Controller.TopStoriesControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.Conn

  alias HackerNewsAggregator.Core.StoryStorage
  alias HackerNewsAggregator.Controller.TopStoriesController

  setup do
    {:ok, _} = StoryStorage.start_link(name: __MODULE__)

    %{storage: __MODULE__}
  end

  describe "get_top_stories/1" do
    test "when StoryStorage doesnt have stories", %{storage: storage} do
      conn = conn(:get, "/top_stories", %{"page" => "1"})

      assert %Conn{
               state: :sent,
               status: 200,
               resp_body: "{\"page\":1,\"top_stories\":[],\"total_pages\":0}"
             } = TopStoriesController.get_top_stories(conn, storage)
    end

    test "when StoryStorage have stories but page param is more than existing pages", %{
      storage: storage
    } do
      StoryStorage.put_top_stories(storage, 1..50)
      conn = conn(:get, "/top_stories", %{"page" => "10"})

      assert %Conn{
               state: :sent,
               status: 200,
               resp_body: "{\"page\":10,\"top_stories\":[],\"total_pages\":1}"
             } = TopStoriesController.get_top_stories(conn, storage)
    end

    test "when StoryStorage have stories but page param is invalid", %{
      storage: storage
    } do
      StoryStorage.put_top_stories(storage, 1..50)
      conn = conn(:get, "/top_stories", %{"page" => "not_number"})

      assert %Conn{
               state: :sent,
               status: 400,
               resp_body: "Page parameter invalid"
             } = TopStoriesController.get_top_stories(conn, storage)
    end

    test "when StoryStorage have stories", %{storage: storage} do
      StoryStorage.put_top_stories(storage, 1..50)
      conn = conn(:get, "/top_stories", %{"page" => "1"})

      assert %Conn{
               state: :sent,
               status: 200,
               resp_body: "{\"page\":1,\"top_stories\":[1,2,3,4,5,6,7,8,9,10],\"total_pages\":5}"
             } = TopStoriesController.get_top_stories(conn, storage)
    end

    test "when StoryStorage have stories and page param is 2", %{storage: storage} do
      StoryStorage.put_top_stories(storage, 1..50)
      conn = conn(:get, "/top_stories", %{"page" => "2"})

      assert %Conn{
               state: :sent,
               status: 200,
               resp_body:
                 "{\"page\":2,\"top_stories\":[11,12,13,14,15,16,17,18,19,20],\"total_pages\":5}"
             } = TopStoriesController.get_top_stories(conn, storage)
    end
  end
end
