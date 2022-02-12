defmodule HackerNewsAggregator.Core.Registry do
  use Agent

  @doc """
  Starts a new registry.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: :registry)
  end

  @doc """
  Gets a value from the `registry` by `key`.
  """
  def get(registry, key) do
    Agent.get(registry, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `registry`.
  """
  def put(registry, key, value) do
    Agent.update(registry, &Map.put(&1, key, value))
  end
end
