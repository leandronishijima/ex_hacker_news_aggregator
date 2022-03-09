defmodule HackerNewsAggregator.Core do
  @moduledoc """
  Module responsible for connecting the core business to customer calls.
  """

  alias HackerNewsAggregator.{
    Core.StoryStorage,
    Core.Paginator,
    HackerNews.Api
  }

  @doc """
  Get top stories with pagination, returning a json as result.

  ## Examples

    iex> get_paginate_top_stories(HackerNewsAggregator.Core.StoryStorage, %{"page" => 1})
    "{\"page\":1,\"top_stories\":[1,2,3,4,5,6,7,8,9,10],\"total_pages\":1}"

    iex> get_paginate_top_stories(HackerNewsAggregator.Core.StoryStorage, %{"page" => -1})
    "{\"page\":0,\"top_stories\":[],\"total_pages\":1}"
  """
  @spec get_paginate_top_stories(atom(), %{required(String.t()) => non_neg_integer()}) ::
          String.t()
  def get_paginate_top_stories(storage \\ StoryStorage, params) do
    storage
    |> StoryStorage.get_top_stories()
    |> paginate(params)
    |> to_json()
  end

  @doc """
  Get top stories without pagination, returning a list of stories id.

  ## Example
    iex> get_top_stories()
    [30518094,30515014,30517049,30513041,30515750,30485709,30515201,30519936,30512512,30514757]

    iex> get_top_stories(HackerNewsAggregator.Core.StoryStorage)
    [30518094,30515014,30517049,30513041,30515750,30485709,30515201,30519936,30512512,30514757]
  """
  @spec get_top_stories(storage :: atom() | none()) :: String.t()
  def get_top_stories(storage \\ StoryStorage) do
    storage
    |> StoryStorage.get_top_stories()
    |> to_json()
  end

  @doc """
  Get details from a single story, returning string in jason format.

  ## Example

    iex> get_item(30518094)
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

    iex> get_item(not_existent_id)
    nil
  """
  @spec get_item(item_id :: String.t()) :: String.t()
  def get_item(item_id) do
    {:ok, item_found} = Api.item(item_id)

    unless is_nil(item_found) do
      {:ok, item_json} = to_json(item_found)
      item_json
    else
      nil
    end
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
