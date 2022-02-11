defmodule HackerNewsAggregator.Endpoint do
  use Plug.Router

  alias HackerNewsAggregator.Core.Database

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/top_stories" do
    top_stories = GenServer.call(Database, :get_top_stories)

    {:ok, json_top_stories} =
      %{
        "top_stories" => top_stories
      }
      |> Jason.encode()

    send_resp(conn, 200, json_top_stories)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
