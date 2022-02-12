defmodule HackerNewsAggregator.Core.RegistryTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.Registry
  @server_name __MODULE__

  setup do
    {:ok, registry} = Registry.start_link(name: @server_name)
    %{registry: registry}
  end

  describe "put/3" do
    test "when you put an array of numbers" do
      assert Registry.get(@server_name, "top_stories") == nil

      assert :ok =
               Registry.put(@server_name, "top_stories", [
                 30_237_457,
                 30_237_846,
                 30_233_630,
                 30_233_472
               ])
    end
  end

  describe "get/2" do
    test "when not have any value registred" do
      assert is_nil(Registry.get(@server_name, "top_stories"))
    end

    test "when have a value registred" do
      Registry.put(@server_name, "top_stories", [30_237_457])

      assert [30_237_457] == Registry.get(@server_name, "top_stories")
    end
  end
end
