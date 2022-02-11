defmodule HackerNewsAggregator.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_hacker_news_aggregator,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {HackerNewsAggregator.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.10"},
      {:jason, "~> 1.3"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end
end
