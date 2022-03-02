defmodule HackerNewsAggregator.Controller.TopStoriesController do
  import Plug.Conn

  alias HackerNewsAggregator.Api

  def get_top_stories(conn, api \\ Api) do
    response_json = Api.get_paginate_top_stories(api, conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end
end
