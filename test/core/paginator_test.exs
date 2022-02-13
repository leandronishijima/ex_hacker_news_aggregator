defmodule HackerNewsAggregator.Core.PaginatorTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.Paginator

  setup do
    {:ok, paginator} = Paginator.start_link(name: __MODULE__)

    %{paginator: paginator}
  end

  describe "paginate/3" do
    test "when list is empty", %{paginator: paginator} do
      assert %Paginator{list: [], page: 2, total_pages: 0} ==
               Paginator.paginate(paginator, [], 2)
    end

    test "when list is not empty", %{paginator: paginator} do
      assert %Paginator{list: [1, 2, 3], page: 1, total_pages: 1} ==
               Paginator.paginate(paginator, 1..3, 1)
    end

    test "when list has 20 lenght and page equal 1", %{paginator: paginator} do
      assert %Paginator{
               list: [
                 1,
                 2,
                 3,
                 4,
                 5,
                 6,
                 7,
                 8,
                 9,
                 10
               ],
               page: 1,
               total_pages: 2
             } == Paginator.paginate(paginator, 1..20, 1)
    end

    test "when list has 20 lenght and page equal 2", %{paginator: paginator} do
      assert %Paginator{
               list: [
                 11,
                 12,
                 13,
                 14,
                 15,
                 16,
                 17,
                 18,
                 19,
                 20
               ],
               page: 2,
               total_pages: 2
             } == Paginator.paginate(paginator, 1..20, 2)
    end

    test "when list has 21 lenght and page equal 3", %{paginator: paginator} do
      stories = 1..21

      assert %Paginator{list: [21], page: 3, total_pages: 3} ==
               Paginator.paginate(paginator, stories, 3)
    end

    test "when list has 50 lenght and page equal 4", %{paginator: paginator} do
      assert %Paginator{
               list: [
                 31,
                 32,
                 33,
                 34,
                 35,
                 36,
                 37,
                 38,
                 39,
                 40
               ],
               page: 4,
               total_pages: 5
             } ==
               Paginator.paginate(paginator, 1..50, 4)
    end
  end
end
