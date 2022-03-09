import Config

config :ex_hacker_news_aggregator,
  hacker_news_api: HackerNewsAggregator.HackerNews.ApiImpl

import_config "#{config_env()}.exs"
