defmodule HackerNewsAggregator.HackerNewsClient.ApiClient do
  alias Finch.Response

  @base_url "https://hacker-news.firebaseio.com/v0"

  def child_spec(_) do
    {Finch, name: __MODULE__}
  end

  def top_stories, do: get("#{@base_url}/topstories.json")

  def item(item_id), do: get("#{@base_url}/item/#{item_id}.json")

  defp get(url) do
    :get
    |> Finch.build(url)
    |> Finch.request(__MODULE__)
    |> parse_response()
  end

  defp parse_response({:ok, %Response{body: body, status: 200}}) do
    Jason.decode(body)
  end
end
