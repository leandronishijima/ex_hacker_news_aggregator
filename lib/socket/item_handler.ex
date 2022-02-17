defmodule HackerNewsAggregator.Socket.ItemHandler do
  @behaviour :cowboy_websocket

  alias HackerNewsAggregator.Api

  def init(%{bindings: %{id: item_id}} = req, _state) do
    {:cowboy_websocket, req, %{item_id: item_id}}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, _message}, %{item_id: item_id} = state) do
    response_json = Api.get_item(Api, item_id)
    {:reply, {:text, response_json}, state}
  end

  def websocket_info(_info, state) do
    {:reply, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
