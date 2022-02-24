defmodule HackerNewsAggregator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, args) do
    children = [
      Registry.child_spec(
        args ++
          [
            name: Registry,
            keys: :unique,
            partitions: System.schedulers_online()
          ]
      ),
      HackerNewsAggregator.Core.Registry.child_spec(args),
      HackerNewsAggregator.Core.PubSub.child_spec(registry: Registry),
      HackerNewsAggregator.HackerNewsClient.ApiClient.child_spec(args),
      HackerNewsAggregator.Task.FetchTopStories.child_spec(args),
      HackerNewsAggregator.Core.Paginator.child_spec(args),
      HackerNewsAggregator.Api.child_spec(args),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: HackerNewsAggregator.Endpoint,
        options: [
          dispatch: dispatch(),
          port: 4001
        ]
      )
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
