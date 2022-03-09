defmodule HackerNewsAggregator.Core.StoryStorage do
  use Agent

  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    Agent.start_link(fn -> %{} end, opts)
  end

  def get_top_stories(story_storage \\ __MODULE__) do
    get(story_storage, "top_stories")
  end

  defp get(story_storage, key) do
    Agent.get(story_storage, &Map.get(&1, key))
  end

  def put_top_stories(story_storage \\ __MODULE__, stories) do
    put(story_storage, "top_stories", stories)
  end

  defp put(story_storage, key, value) do
    Agent.update(story_storage, &Map.put(&1, key, value))
  end
end
