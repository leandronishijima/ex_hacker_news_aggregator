defmodule HackerNewsAggregator.Endpoint do
  use Plug.Router

  alias HackerNewsAggregator.{
    Core.Database,
    HackerNewsClient.ApiClient
  }

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/top_stories" do
    top_stories = GenServer.call(Database, :get_top_stories)

    {:ok, response_json} =
      %{"top_stories" => top_stories}
      |> Jason.encode()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  get "/item" do
    {:ok, item} = ApiClient.item(30_290_225)

    {:ok, response_json} =
      %{
        "item" => item
      }
      |> Jason.encode()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
