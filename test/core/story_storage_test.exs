defmodule HackerNewsAggregator.Core.StoryStorageTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.StoryStorage

  @server_name __MODULE__

  setup do
    {:ok, registry} = StoryStorage.start_link(name: @server_name)
    %{registry: registry}
  end

  describe "put_top_stories/2" do
    test "when you put an array of numbers" do
      assert StoryStorage.get_top_stories(@server_name) == nil

      assert :ok =
               StoryStorage.put_top_stories(@server_name, [
                 30_237_457,
                 30_237_846,
                 30_233_630,
                 30_233_472
               ])

      assert StoryStorage.get_top_stories(@server_name) == [
               30_237_457,
               30_237_846,
               30_233_630,
               30_233_472
             ]
    end
  end

  describe "get_top_stories/1" do
    test "when not have any value registred" do
      assert is_nil(StoryStorage.get_top_stories(@server_name))
    end

    test "when have a value registred" do
      StoryStorage.put_top_stories(@server_name, [30_237_457])

      assert [30_237_457] == StoryStorage.get_top_stories(@server_name)
    end
  end
end
