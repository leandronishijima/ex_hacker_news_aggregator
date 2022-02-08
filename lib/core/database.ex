defmodule HackerNewsAggregator.Core.Database do
  use GenServer

  @table_name :stories

  def child_spec(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    {:ok, create_table()}
  end

  defp create_table, do: :ets.new(@table_name, [:set, :protected, :named_table])

  @impl true
  def handle_cast({:push, stories}, state) do
    insert({"top_stories", stories})
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_top_stories, _from, state) do
    {:reply, lookup("top_stories"), state}
  end

  defp insert({_key, _value} = content) do
    :ets.insert(@table_name, content)
  end

  defp lookup(key) do
    case :ets.lookup(@table_name, key) do
      [{^key, values}] -> values
      _ -> []
    end
  end
end
