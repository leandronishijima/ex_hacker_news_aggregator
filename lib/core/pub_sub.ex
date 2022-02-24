defmodule HackerNewsAggregator.Core.PubSub do
  use GenServer

  @registry_key_websockets "connected_websockets"

  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  def start_link(opts \\ []) do
    server_name = Access.get(opts, :name, __MODULE__)
    registry_name = Access.get(opts, :registry, __MODULE__)

    state =
      Map.new()
      |> Map.put_new(:name, Access.get(opts, :name, server_name))
      |> Map.put_new(:registry, Access.get(opts, :registry, registry_name))

    GenServer.start_link(__MODULE__, {:ok, state}, name: server_name)
  end

  @impl true
  def init({:ok, opts}) do
    {:ok, opts}
  end

  def broadcast(pubsub \\ __MODULE__, top_stories) do
    GenServer.cast(pubsub, {:broadcast, top_stories})
  end

  def subscribe_websocket(pubsub \\ __MODULE__, pid) do
    GenServer.cast(pubsub, {:subscribe_websocket, pid})
  end

  @impl true
  def handle_cast({:broadcast, top_stories}, %{registry: registry} = state) do
    Registry.dispatch(registry, @registry_key_websockets, fn entries ->
      for {_owner, websocket_pid} <- entries do
        send(websocket_pid, {:broadcast, top_stories})
      end
    end)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:subscribe_websocket, pid}, %{registry: registry} = state) do
    Registry.register(registry, @registry_key_websockets, pid)

    {:noreply, state}
  end

  @impl true
  def handle_info(:info, state) do
    {:noreply, state}
  end
end
