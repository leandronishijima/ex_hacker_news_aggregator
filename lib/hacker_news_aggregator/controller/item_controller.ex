defmodule HackerNewsAggregator.Controller.ItemController do
  @moduledoc """
  Module controller responsible to receive http connections and return 
  details from a specific item from Hacker News api.
  """

  import Plug.Conn

  alias HackerNewsAggregator.Core

  @doc """
  Return %Plug.Conn{} with details from item in json format.

  Returns `%Plug.Conn{}`
  """
  @spec get_item(%Plug.Conn{}, id :: String.t()) :: %Plug.Conn{}
  def get_item(conn, id) do
    case Integer.parse(id) do
      {_number, _} ->
        Core.get_item(id)
        |> send_response(conn)

      :error ->
        send_error(conn)
    end
  end

  defp send_error(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, "Id parameter is invalid")
  end

  defp send_response(response_json, conn) do
    conn =
      conn
      |> put_resp_content_type("application/json")

    if is_nil(response_json) do
      send_resp(conn, 404, "Item not found")
    else
      send_resp(conn, 200, response_json)
    end
  end
end
