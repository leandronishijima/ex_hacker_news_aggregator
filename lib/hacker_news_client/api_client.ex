defmodule HackerNewsAggregator.HackerNewsClient.ApiClient do
  @base_url "https://hacker-news.firebaseio.com/v0"

  def child_spec(_) do
    {Finch, name: __MODULE__}
  end

  def get_top_stories do
    :get
    |> Finch.build("#{@base_url}/topstories.json")
    |> Finch.request(__MODULE__)
  end
end
