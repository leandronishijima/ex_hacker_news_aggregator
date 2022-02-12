defmodule HackerNewsAggregator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, args) do
    children = [
      # Starts a worker by calling: HackerNewsAggregator.Worker.start_link(arg)
      # {HackerNewsAggregator.Worker, arg}
      HackerNewsAggregator.Core.Registry.child_spec(args),
      HackerNewsAggregator.HackerNewsClient.ApiClient.child_spec(args),
      HackerNewsAggregator.Task.FetchTopStories.child_spec(args),
      HackerNewsAggregator.Core.Paginator.child_spec(args),
      HackerNewsAggregator.Api.child_spec(args),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: HackerNewsAggregator.Endpoint,
        options: [port: 4001]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HackerNewsAggregator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
