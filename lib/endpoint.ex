defmodule HackerNewsAggregator.Endpoint do
  use Plug.Router

  alias HackerNewsAggregator.Controller.{TopStoriesController, ItemController}

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/top_stories" do
    TopStoriesController.get_top_stories(conn)
  end

  get "/item/:id" do
    ItemController.get_item(conn, id)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
