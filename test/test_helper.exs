ExUnit.start()

Mox.defmock(HackerNewsAggregator.HackerNews.MockApi,
  for: HackerNewsAggregator.HackerNews.Api
)

Application.put_env(
  :ex_hacker_news_aggregator,
  :hacker_news_api,
  HackerNewsAggregator.HackerNews.MockApi
)
