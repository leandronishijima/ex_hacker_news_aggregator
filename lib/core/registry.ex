defmodule HackerNewsAggregator.Core.Registry do
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
