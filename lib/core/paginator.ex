defmodule HackerNewsAggregator.Core.Paginator do
  use GenServer

  @name __MODULE__

  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def paginate(paginator, list, page) do
    GenServer.call(paginator, {:paginate, list, page})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:paginate, [], _page}, _from, state) do
    {:reply, [], state}
  end

  @impl true
  def handle_call({:paginate, list, page}, _from, state) do
    list =
      Enum.chunk_every(list, 10)
      |> Enum.at(page - 1)

    {:reply, list, state}
  end
end
