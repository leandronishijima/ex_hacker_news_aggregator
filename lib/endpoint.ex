defmodule HackerNewsAggregator.Endpoint do
  use Plug.Router

  alias HackerNewsAggregator.{
    Core.Registry,
    HackerNewsClient.ApiClient
  }

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/top_stories" do
    top_stories = Registry.get(:registry, "top_stories")

    {:ok, response_json} = Jason.encode(%{"top_stories" => top_stories})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  get "/item/:id" do
    {:ok, item} = ApiClient.item(id)

    {:ok, response_json} = Jason.encode(%{"item" => item})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
