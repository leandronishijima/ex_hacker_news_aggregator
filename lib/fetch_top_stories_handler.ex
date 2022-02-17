defmodule HackerNewsAggregator.Socket.FetchTopStoriesHandler do
  @behaviour :cowboy_websocket

  alias HackerNewsAggregator.Api

  def init(req, _state) do
    {:cowboy_websocket, req, %{query: req.qs}}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, _message}, %{query: query} = state) do
    response_json = Api.get_paginate_top_stories(Api, query)
    {:reply, {:text, response_json}, state}
  end

  def websocket_info(_info, state) do
    {:reply, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
