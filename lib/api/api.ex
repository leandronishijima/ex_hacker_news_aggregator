defmodule HackerNewsAggregator.Api do
  use GenServer

  alias HackerNewsAggregator.{
    Core.Registry,
    Core.Paginator,
    HackerNewsClient.ApiClient
  }

  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get_paginate_top_stories(api, params) do
    GenServer.call(api, {:paginate_top_stories, params})
  end

  def get_item(api, item_id) do
    GenServer.call(api, {:item, item_id})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:paginate_top_stories, params}, _from, state) do
    %Paginator{list: paginated_top_stories, page: page, total_pages: total_pages} =
      Registry.get(Registry, "top_stories")
      |> paginate(params)

    {:ok, response_json} =
      Jason.encode(%{
        "top_stories" => paginated_top_stories,
        "page" => page,
        "total_pages" => total_pages
      })

    {:reply, response_json, state}
  end

  @impl true
  def handle_call({:item, id}, _from, state) do
    {:ok, item} = ApiClient.item(id)

    {:ok, response_json} = to_json(item)

    {:reply, response_json, state}
  end

  defp to_json(struct) do
    Jason.encode(struct)
  end

  defp paginate(list, %{"page" => page_param}) do
    {page, _} = Integer.parse(page_param)
    Paginator.paginate(Paginator, list, page)
  end
end
