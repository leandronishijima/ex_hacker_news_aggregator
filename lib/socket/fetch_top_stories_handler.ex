defmodule HackerNewsAggregator.Socket.FetchTopStoriesHandler do
  @behaviour :cowboy_websocket

  alias HackerNewsAggregator.Api

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, _message}, state) do
    # TODO verify if pid is already registred
    {:ok, _pid} = Registry.register(Registry, "connected_websockets", self())

    top_stories = Api.get_top_stories(Api)

    {:reply, {:text, top_stories}, state}
  end

  # broadcast handle here
  def websocket_info({:broadcast, raw_top_stories}, state) do
    top_stories = Jason.encode!(raw_top_stories)
    {:reply, {:text, top_stories}, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
