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
      HackerNewsAggregator.Core.Database.child_spec(args),
      HackerNewsAggregator.HackerNewsClient.ApiClient.child_spec(args),
      HackerNewsAggregator.Core.FetchTopStories.child_spec(args),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: HackerNewsAggregator.Endpoint,
        # dispatch: dispatch,
        options: [port: 4001]
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
         {"/socket", HackerNewsAggregator.Socket, []},
         {:_, Plug.Adapters.Cowboy.Handler, {HackerNewsAggregator.Router, []}}
       ]}
    ]
  end
end
