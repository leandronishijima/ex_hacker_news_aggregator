defmodule HackerNewsAggregator.Core.Paginator do
  use GenServer

  @name __MODULE__

  defstruct list: [], page: 0, total_pages: 0, valid?: false

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
  def handle_call({:paginate, [], page}, _from, state) when page > 1 do
    {:reply, %__MODULE__{valid?: false, page: page}, state}
  end

  @impl true
  def handle_call({:paginate, list, page}, _from, state) do
    chuncked_list = Enum.chunk_every(list, 10)

    paginated_list = Enum.at(chuncked_list, page - 1)

    {:reply,
     %__MODULE__{
       valid?: true,
       list: paginated_list,
       page: page,
       total_pages: length(chuncked_list)
     }, state}
  end
end
