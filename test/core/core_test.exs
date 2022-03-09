defmodule HackerNewsAggregator.CoreTest do
  use ExUnit.Case, async: true

  import Mox

  alias HackerNewsAggregator.{Core, Core.StoryStorage}

  setup do
    {:ok, _} = StoryStorage.start_link(name: :story_storage_test)

    %{storage: :story_storage_test}
  end

  setup :verify_on_exit!

  describe "get_paginate_top_stories/2" do
    test "when registry have stories and the page number is negative", %{
      storage: storage
    } do
      StoryStorage.put_top_stories(storage, 1..10)

      assert "{\"page\":0,\"top_stories\":[],\"total_pages\":1}" ==
               Core.get_paginate_top_stories(storage, %{"page" => -1})
    end

    test "when registry have stories", %{storage: storage} do
      StoryStorage.put_top_stories(storage, 1..10)

      assert "{\"page\":1,\"top_stories\":[1,2,3,4,5,6,7,8,9,10],\"total_pages\":1}" ==
               Core.get_paginate_top_stories(storage, %{"page" => 1})
    end

    test "when registry doesn`t have stories", %{storage: storage} do
      assert "{\"page\":1,\"top_stories\":[],\"total_pages\":0}" ==
               Core.get_paginate_top_stories(storage, %{"page" => 1})
    end

    test "when page is invalid", %{storage: storage} do
      StoryStorage.put_top_stories(storage, 1..10)

      assert "{\"page\":2,\"top_stories\":[],\"total_pages\":1}" ==
               Core.get_paginate_top_stories(storage, %{"page" => 2})
    end

    test "when registry have more than ten stories", %{storage: storage} do
      StoryStorage.put_top_stories(storage, 1..50)

      assert "{\"page\":5,\"top_stories\":[41,42,43,44,45,46,47,48,49,50],\"total_pages\":5}" ==
               Core.get_paginate_top_stories(storage, %{"page" => 5})
    end
  end

  describe "get_item/1" do
    test "when item doesnt exists" do
      HackerNewsAggregator.HackerNews.MockApi
      |> expect(:item, fn _item_id -> {:ok, nil} end)

      assert is_nil(Core.get_item(199_910_101))
    end
  end
end
