defmodule HackerNewsAggregator.ApiTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.{Api, Core.StoryStorage, Core.Paginator}

  setup do
    {:ok, _} = StoryStorage.start_link(name: :story_storage_test)
    {:ok, _} = Paginator.start_link(name: :paginator_test)

    {:ok, api} =
      Api.start_link(name: __MODULE__, storage: :story_storage_test, paginator: :paginator_test)

    %{api: api, storage: :story_storage_test}
  end

  describe "get_paginate_top_stories/2" do
    test "when registry have stories", %{api: api, storage: storage} do
      StoryStorage.put(storage, "top_stories", 1..10)

      assert "{\"page\":1,\"top_stories\":[1,2,3,4,5,6,7,8,9,10],\"total_pages\":1}" ==
               Api.get_paginate_top_stories(api, %{"page" => "1"})
    end

    test "when registry doesn`t have stories", %{api: api} do
      assert "{\"page\":1,\"top_stories\":[],\"total_pages\":0}" ==
               Api.get_paginate_top_stories(api, %{"page" => "1"})
    end

    test "when page is invalid", %{api: api, storage: storage} do
      StoryStorage.put(storage, "top_stories", 1..10)

      assert "{\"page\":2,\"top_stories\":[],\"total_pages\":1}" ==
               Api.get_paginate_top_stories(api, %{"page" => "2"})
    end

    test "when registry have more than ten stories", %{api: api, storage: storage} do
      StoryStorage.put(storage, "top_stories", 1..50)

      assert "{\"page\":5,\"top_stories\":[41,42,43,44,45,46,47,48,49,50],\"total_pages\":5}" ==
               Api.get_paginate_top_stories(api, %{"page" => "5"})
    end
  end
end
