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

    test "when list is not empty", %{paginator: paginator} do
      assert [1, 2, 3] == Paginator.paginate(paginator, 1..3, 1)
    end

    test "when list has 20 lenght and page equal 1", %{paginator: paginator} do
      assert [
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
             ] == Paginator.paginate(paginator, 1..20, 1)
    end

    test "when list has 20 lenght and page equal 2", %{paginator: paginator} do
      assert [
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
             ] == Paginator.paginate(paginator, 1..20, 2)
    end

    test "when list has 21 lenght and page equal 3", %{paginator: paginator} do
      stories = 1..21

      assert [21] ==
               Paginator.paginate(paginator, stories, 3)
    end

    test "when list has 50 lenght and page equal 4", %{paginator: paginator} do
      assert [
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
             ] ==
               Paginator.paginate(paginator, 1..50, 4)
    end
  end
end
