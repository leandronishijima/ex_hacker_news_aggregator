defmodule HackerNewsAggregator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, args) do
    children = [
      HackerNewsAggregator.HackerNewsClient.ApiClient.child_spec(),
      {Registry, name: Registry, keys: :unique, partitions: System.schedulers()},
      {HackerNewsAggregator.Core.StoryStorage, args},
      {HackerNewsAggregator.Core.PubSub, args},
      {HackerNewsAggregator.Task.FetchTopStories, args},
      {HackerNewsAggregator.Core.Paginator, args},
      {HackerNewsAggregator.Core, args},
      {Plug.Cowboy,
       scheme: :http,
       plug: HackerNewsAggregator.Endpoint,
       options: [dispatch: dispatch(), port: 4001]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HackerNewsAggregator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/top_stories", HackerNewsAggregator.Socket.FetchTopStoriesHandler, []},
         {:_, Plug.Cowboy.Handler, {HackerNewsAggregator.Endpoint, []}}
       ]}
    ]
  end
end
