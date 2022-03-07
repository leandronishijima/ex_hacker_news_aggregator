defmodule HackerNewsAggregator.Core do
  @moduledoc """
  Module responsible for connecting the core business to customer calls.
  """

  use GenServer

  alias HackerNewsAggregator.{
    Core.StoryStorage,
    Core.Paginator,
    HackerNewsClient.ApiClient
  }

  @doc false
  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  @doc false
  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      {:ok, %{storage: Access.get(opts, :storage, StoryStorage)}},
      name: Access.get(opts, :name, __MODULE__)
    )
  end

  @doc false
  @impl true
  def init({:ok, opts}) do
    {:ok, opts}
  end

  @doc """
  Get top stories with pagination, returning a json as result.

  ## Examples

    iex> get_paginate_top_stories(HackerNewsAggregator.Core, %{"page" => 1})
    "{\"page\":1,\"top_stories\":[1,2,3,4,5,6,7,8,9,10],\"total_pages\":1}"

    iex> get_paginate_top_stories(HackerNewsAggregator.Core, %{"page" => -1})
    "{\"page\":0,\"top_stories\":[],\"total_pages\":1}"
  """
  @spec get_paginate_top_stories(atom(), %{required(String.t()) => non_neg_integer()}) ::
          String.t()
  def get_paginate_top_stories(core \\ __MODULE__, params) do
    GenServer.call(core, {:paginate_top_stories, params})
  end

  @doc """
  Get top stories without pagination, returning a list of stories id.

  ## Example

    iex> get_top_stories(HackerNewsAggregator.Core)
    [30518094,30515014,30517049,30513041,30515750,30485709,30515201,30519936,30512512,30514757]
  """
  @spec get_top_stories(atom()) :: list(non_neg_integer())
  def get_top_stories(core \\ __MODULE__) do
    GenServer.call(core, :top_stories)
  end

  @doc """
  Get details from a single story, returning string in jason format.

  ## Example

    iex> get_item(HackerNewsAggregator.Core, 30518094)
    "{
      \"by\": \"akprasad\",
      \"descendants\": 57,
      \"id\": 30223559,
      \"kids\": [30224014,30224483,30225709,30227150],
      \"score\": 284,
      \"time\": 1644083044,
      \"title\": \"Unlearning perfectionism\",
      \"type\": \"story\",
      \"url\": \"https://arunkprasad.com/log/unlearning-perfectionism/\"
    }"

    iex> get_item(HackerNewsAggregator.Core, not_existent_id)
    nil
  """
  @spec get_item(atom(), non_neg_integer()) :: String.t()
  def get_item(core \\ __MODULE__, item_id) do
    GenServer.call(core, {:item, item_id})
  end

  @doc false
  @impl true
  def handle_call(
        {:paginate_top_stories, params},
        _from,
        %{storage: storage} = state
      ) do
    response_json =
      storage
      |> StoryStorage.get_top_stories()
      |> paginate(params)
      |> to_json()

    {:reply, response_json, state}
  end

  @doc false
  @impl true
  def handle_call(
        :top_stories,
        _from,
        %{storage: storage} = state
      ) do
    top_stories =
      storage
      |> StoryStorage.get_top_stories()
      |> to_json()

    {:reply, top_stories, state}
  end

  @doc false
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

  defp paginate(nil, %{"page" => page_param}) do
    Paginator.paginate([], page_param)
  end

  defp paginate(list, %{"page" => page_param}) do
    Paginator.paginate(list, page_param)
  end
end
