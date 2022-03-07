defmodule HackerNewsAggregator.Socket.FetchTopStoriesHandler do
  @behaviour :cowboy_websocket

  alias HackerNewsAggregator.Core
  alias HackerNewsAggregator.Core.PubSub

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def init(req, state \\ []) do
    pubsub = Access.get(state, :pubsub, PubSub)

    state =
      Map.new()
      |> Map.put_new(:pubsub, Access.get(state, :pubsub, pubsub))

    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, _message}, %{pubsub: pubsub} = state) do
    top_stories = Core.get_top_stories()

    PubSub.subscribe_websocket(pubsub, self())

    {:reply, {:text, top_stories}, state}
  end

  def websocket_info({:broadcast, raw_top_stories}, state) do
    {:ok, top_stories} = Jason.encode(raw_top_stories)
    {:reply, {:text, top_stories}, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
