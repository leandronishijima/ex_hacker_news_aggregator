defmodule HackerNewsAggregator.Controller.ItemController do
  import Plug.Conn

  alias HackerNewsAggregator.Api

  def get_item(conn, id, api \\ Api) do
    response_json = Api.get_item(api, id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end
end
