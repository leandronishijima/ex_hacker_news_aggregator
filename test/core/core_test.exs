defmodule HackerNewsAggregator.CoreTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.{Core, Core.StoryStorage}

  setup do
    {:ok, _} = StoryStorage.start_link(name: :story_storage_test)
    {:ok, core} = Core.start_link(name: __MODULE__, storage: :story_storage_test)

    %{core: core, storage: :story_storage_test}
  end

  describe "get_paginate_top_stories/2" do
    test "when registry have stories and the page number is negative", %{
      core: core,
      storage: storage
    } do
      StoryStorage.put_top_stories(storage, 1..10)

      assert "{\"page\":0,\"top_stories\":[],\"total_pages\":1}" ==
               Core.get_paginate_top_stories(core, %{"page" => "-1"})
    end

    test "when registry have stories", %{core: core, storage: storage} do
      StoryStorage.put_top_stories(storage, 1..10)

      assert "{\"page\":1,\"top_stories\":[1,2,3,4,5,6,7,8,9,10],\"total_pages\":1}" ==
               Core.get_paginate_top_stories(core, %{"page" => "1"})
    end

    test "when registry doesn`t have stories", %{core: core} do
      assert "{\"page\":1,\"top_stories\":[],\"total_pages\":0}" ==
               Core.get_paginate_top_stories(core, %{"page" => "1"})
    end

    test "when page is invalid", %{core: core, storage: storage} do
      StoryStorage.put_top_stories(storage, 1..10)

      assert "{\"page\":2,\"top_stories\":[],\"total_pages\":1}" ==
               Core.get_paginate_top_stories(core, %{"page" => "2"})
    end

    test "when registry have more than ten stories", %{core: core, storage: storage} do
      StoryStorage.put_top_stories(storage, 1..50)

      assert "{\"page\":5,\"top_stories\":[41,42,43,44,45,46,47,48,49,50],\"total_pages\":5}" ==
               Core.get_paginate_top_stories(core, %{"page" => "5"})
    end
  end
end
