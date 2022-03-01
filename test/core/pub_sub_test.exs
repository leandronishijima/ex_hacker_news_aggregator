defmodule HackerNewsAggregator.Core.PubSubTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.PubSub

  setup do
    registry_name = :registry_test
    {:ok, _} = start_supervised({Registry, name: registry_name, keys: :unique})

    {:ok, pubsub} = PubSub.start_link(name: __MODULE__, registry: registry_name)

    {:ok, pubsub: pubsub, registry: registry_name}
  end

  describe "subscribe_websocket/2" do
    test "when you try to subscribe an process with pid", %{pubsub: pubsub, registry: registry} do
      PubSub.subscribe_websocket(pubsub, self())

      assert [{pubsub, self()}] ==
               Registry.lookup(registry, "connected_websockets")
    end
  end

  describe "broadcast/2" do
    test "when you broadcast with empty subscribes", %{pubsub: pubsub} do
      PubSub.broadcast(pubsub, [30_237_457, 30_190_717, 30_237_483])

      refute_receive {:broadcast, [30_237_457, 30_190_717, 30_237_483]}
    end

    test "when you broadcast with subscribes", %{pubsub: pubsub, registry: registry} do
      PubSub.broadcast(pubsub, [30_237_457, 30_190_717, 30_237_483])
      Registry.register(registry, "connected_websockets", self())

      assert_received {:broadcast, [30_237_457, 30_190_717, 30_237_483]}
    end
  end
end
