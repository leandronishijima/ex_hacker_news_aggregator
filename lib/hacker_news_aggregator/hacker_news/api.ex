defmodule HackerNewsAggregator.HackerNews.Api do
  @moduledoc """
  Module responsible to define a behaviour to Api implementation.
  """

  @callback top_stories() :: {:ok, list(non_neg_integer())}
  @callback item(id :: String.t()) :: {:ok, map()}

  def top_stories(), do: impl().top_stories()
  def item(id), do: impl().item(id)

  defp impl,
    do:
      Application.get_env(
        :ex_hacker_news_aggregator,
        :hacker_news_api,
        HackerNewsAggregator.HackerNews.Api
      )
end
