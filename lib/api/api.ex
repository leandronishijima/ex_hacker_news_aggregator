defmodule HackerNewsAggregator.Api do
  use GenServer

  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def get_paginate_top_stories(page) do
    GenServer.cast(:paginate_top_stories)
  end

  def handle_cast(:paginate_top_stories, state) do
  end
end
