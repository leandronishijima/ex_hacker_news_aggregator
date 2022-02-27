defmodule HackerNewsAggregator.Core.StoryStorage do
  use Agent

  @name __MODULE__

  @doc """
  Starts a new registry.
  """
  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    Agent.start_link(fn -> %{} end, opts)
  end

  @doc """
  Gets a value from the `registry` by `key`.
  """
  def get(story_storage, key) do
    Agent.get(story_storage, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `registry`.
  """
  def put(story_storage, key, value) do
    Agent.update(story_storage, &Map.put(&1, key, value))
  end
end
