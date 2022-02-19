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

  def get_top_stories(api \\ __MODULE__) do
    GenServer.call(api, :top_stories)
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
    response_json =
      registry
      |> Registry.get("top_stories")
      |> paginate(paginator, params)
      |> to_json()

    {:reply, response_json, state}
  end

  @impl true
  def handle_call(
        :top_stories,
        _from,
        %{registry: registry} = state
      ) do
    top_stories =
      registry
      |> Registry.get("top_stories")
      |> to_json()

    {:reply, top_stories, state}
  end

  @impl true
  def handle_call({:item, id}, _from, state) do
    {:ok, item} = ApiClient.item(id)

    {:ok, response_json} = to_json(item)

    {:reply, response_json, state}
  end

  defp to_json(%Paginator{valid?: false, page: page}) do
    {:ok, response_json} =
      Jason.encode(%{
        "top_stories" => [],
        "page" => page,
        "total_pages" => 1
      })

    response_json
  end

  defp to_json(%Paginator{
         valid?: true,
         list: paginated_top_stories,
         page: page,
         total_pages: total_pages
       }) do
    {:ok, response_json} =
      Jason.encode(%{
        "top_stories" => paginated_top_stories,
        "page" => page,
        "total_pages" => total_pages
      })

    response_json
  end

  defp to_json(list) when is_list(list) do
    {:ok, response_json} = Jason.encode(list)

    response_json
  end

  defp to_json(struct), do: Jason.encode(struct)

  defp paginate(nil, paginator, %{"page" => page_param}) do
    Paginator.paginate(paginator, [], to_integer(page_param))
  end

  defp paginate(list, paginator, %{"page" => page_param}) do
    Paginator.paginate(paginator, list, to_integer(page_param))
  end

  defp to_integer(string_number) when is_binary(string_number) do
    {integer, _} = Integer.parse(string_number)
    integer
  end
end
