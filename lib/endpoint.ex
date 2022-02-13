defmodule HackerNewsAggregator.Endpoint do
  use Plug.Router

  alias HackerNewsAggregator.{
    Core.Registry,
    Core.Paginator,
    HackerNewsClient.ApiClient
  }

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/top_stories" do
    %Paginator{list: paginated_top_stories, page: page, total_pages: total_pages} =
      Registry.get(Registry, "top_stories")
      |> paginate(conn.params)

    {:ok, response_json} =
      Jason.encode(%{
        "top_stories" => paginated_top_stories,
        "page" => page,
        "total_pages" => total_pages
      })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_json)
  end

  defp paginate(list, %{"page" => page_param}) do
    {page, _} = Integer.parse(page_param)
    Paginator.paginate(Paginator, list, page)
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
