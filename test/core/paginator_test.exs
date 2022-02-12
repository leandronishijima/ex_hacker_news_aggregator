defmodule HackerNewsAggregator.Core.PaginatorTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.Paginator

  setup do
    {:ok, paginator} = Paginator.start_link(name: __MODULE__)

    %{paginator: paginator}
  end

  describe "paginate/3" do
    test "when list is empty", %{paginator: paginator} do
      assert [] == Paginator.paginate(paginator, [], 2)
    end
  end
end
