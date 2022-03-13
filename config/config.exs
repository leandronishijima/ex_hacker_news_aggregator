import Config

config :ex_hacker_news_aggregator,
  hacker_news_api: HackerNewsAggregator.HackerNews.ApiImpl,
  fetch_interval_time_in_seconds: 300

import_config "#{config_env()}.exs"
