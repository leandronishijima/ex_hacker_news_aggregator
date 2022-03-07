defmodule HackerNewsAggregator.HackerNews.Api do
  @moduledoc """
  Module reponsible to interface Hacker News Api
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://hacker-news.firebaseio.com/v0")
  plug(Tesla.Middleware.JSON)

  @doc """
  Return the 50 first top stories from hacker news.

  ## Examples
    iex> top_stories()
    {:ok, 
    [
      30582202,
      30580444,
      30566119,
      30582986,
      30579884,
      30582877,
      30581735,
      30578938,
      30583059,
      30566741
    ]
    }
  """
  @spec top_stories() :: {:ok, list(non_neg_integer())}
  def top_stories do
    get("/topstories.json", query: [print: "pretty", limitToFirst: 50, orderBy: "\"$key\""])
    |> return_body()
  end

  @doc """
  Return all details from specific item.

  ## Examples
    iex> item(3029946)
    {:ok
     %{
       "by" => "NY_Entrepreneur",
       "id" => 3029946,
       "parent" => 3028322,
       "text" => "Text from item",
       "kids" => [30293946, 30294081, 30294010, 30295007],
       "time" => 1316785698,
       "type" => "comment"
      }
    }

    iex> item(not_existent_item)
    {:ok, nil}
  """
  @spec item(id :: String.t()) :: {:ok, map()}
  def item(id) do
    get("/item/#{id}.json")
    |> return_body()
  end

  defp return_body({:ok, %Tesla.Env{body: nil}}), do: {:ok, %{}}
  defp return_body({:ok, %Tesla.Env{body: body}}), do: {:ok, body}
end
