defmodule HackerNewsAggregator.Controller.ItemController do
  import Plug.Conn

  alias HackerNewsAggregator.Core

  def get_item(conn, id, api \\ Core) do
    response_json = Core.get_item(api, id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end
end
