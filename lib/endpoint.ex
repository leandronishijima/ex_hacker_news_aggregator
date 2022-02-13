defmodule HackerNewsAggregator.Endpoint do
  use Plug.Router

  alias HackerNewsAggregator.Api

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/top_stories" do
    response_json = Api.get_paginate_top_stories(Api, conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  get "/item/:id" do
    response_json = Api.get_item(Api, id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
