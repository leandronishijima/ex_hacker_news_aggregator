defmodule HackerNewsAggregator.Core.RegistryTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.Registry

  setup do
    {:ok, registry} = Registry.start_link(name: :registry_test)
    %{registry: registry}
  end

  describe "put/3" do
    test "when you put an array of numbers", %{registry: registry} do
      assert Registry.get(registry, "top_stories") == nil

      assert :ok =
               Registry.put(registry, "top_stories", [
                 30_237_457,
                 30_237_846,
                 30_233_630,
                 30_233_472
               ])
    end
  end

  describe "get/2" do
    test "when not have any value registred", %{registry: registry} do
      assert is_nil(Registry.get(registry, "top_stories"))
    end

    test "when have a value registred", %{registry: registry} do
      Registry.put(registry, "top_stories", [30_237_457])

      assert [30_237_457] == Registry.get(registry, "top_stories")
    end
  end
end
