defmodule HackerNewsAggregator.Controller.ItemController do
  @moduledoc """
  Module controller responsible to receive http connections and return 
  details from a specific item from Hacker News api.
  """

  import Plug.Conn

  alias HackerNewsAggregator.Core

  @doc """
  Return %Plug.Conn{} with details from item in json format.
  """
  @spec get_item(%Plug.Conn{}, id :: String.t(), core :: atom()) :: %Plug.Conn{}
  def get_item(conn, id, core \\ Core) do
    case Integer.parse(id) do
      {_number, _} ->
        response_json = Core.get_item(core, id)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, response_json)

      :error ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, "Id parameter is invalid")
    end
  end
end
