defmodule HackerNewsAggregator.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias HackerNewsAggregator.{
    Core.Registry,
    Endpoint
  }

  @opts HackerNewsAggregator.Endpoint.init([])

  setup do
    {:ok, registry} = Registry.start_link(name: :registry_endpoint)
    %{registry: registry}
  end

  describe "/top_stories" do
    test "it returns an array of stories id", %{registry: registry} do
      Registry.put(registry, "top_stories", [
        30_237_846,
        30_233_630,
        30_233_472
      ])

      conn =
        conn(:get, "/top_stories")
        |> Endpoint.call(@opts)

      assert %{
               state: :sent,
               status: 20,
               resp_body: [
                 30_237_846,
                 30_233_630,
                 30_233_472
               ]
             } = conn
    end
  end
end
