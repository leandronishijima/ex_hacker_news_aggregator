defmodule HackerNewsAggregator.Socket.FetchTopStoriesHandler do
  @behaviour :cowboy_websocket

  alias HackerNewsAggregator.Api

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, _message}, state) do
    IO.puts("handle -> PID = #{inspect(self())}")
    top_stories = Api.get_top_stories(Api)
    {:reply, {:text, top_stories}, state}
  end

  # broadcast handle here
  def websocket_info(info, state) do
    IO.inspect("called info = #{info} and state = #{state}")
    {:reply, state}
  end

  def loop(req) do
    receive do
      {:broadcast, data} ->
        IO.puts "received [ #{data} ]"
        __MODULE__.websocket_info({:info, data}, :undefined_state)
        loop(req)
    end
  end


  def terminate(_reason, _req, _state) do
    :ok
  end
end
