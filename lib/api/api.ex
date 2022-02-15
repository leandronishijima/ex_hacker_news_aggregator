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

  def start_link(opts \\ []) do
    server_name = Access.get(opts, :name, __MODULE__)

    opts =
      Map.new()
      |> Map.put_new(:registry, Access.get(opts, :registry, Registry))
      |> Map.put_new(:paginator, Access.get(opts, :paginator, Paginator))

    GenServer.start_link(__MODULE__, {:ok, opts}, name: server_name)
  end

  @impl true
  def init({:ok, opts}) do
    {:ok, opts}
  end

  def get_paginate_top_stories(api \\ __MODULE__, params) do
    GenServer.call(api, {:paginate_top_stories, params})
  end

  def get_item(api \\ __MODULE__, item_id) do
    GenServer.call(api, {:item, item_id})
  end

  @impl true
  def handle_call(
        {:paginate_top_stories, params},
        _from,
        %{registry: registry, paginator: paginator} = state
      ) do
    %Paginator{list: paginated_top_stories, page: page, total_pages: total_pages} =
      Registry.get(registry, "top_stories")
      |> paginate(paginator, params)

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

  defp to_json(struct), do: Jason.encode(struct)

  defp paginate(nil, paginator, %{"page" => page_param}) do
    {page, _} = Integer.parse(page_param)
    Paginator.paginate(paginator, [], page)
  end

  defp paginate(list, paginator, %{"page" => page_param}) do
    {page, _} = Integer.parse(page_param)
    Paginator.paginate(paginator, list, page)
  end
end
