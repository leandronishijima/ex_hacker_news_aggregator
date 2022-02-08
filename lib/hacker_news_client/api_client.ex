defmodule HackerNewsAggregator.HackerNewsClient.ApiClient do
  alias Finch.Response

  @base_url "https://hacker-news.firebaseio.com/v0"
  @params_to_limit_stories "print=pretty&limitToFirst=50&orderBy=%22$key%22"

  def child_spec(_) do
    {Finch, name: __MODULE__}
  end

  def top_stories,
    do: get("#{@base_url}/topstories.json?#{@params_to_limit_stories}")

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
