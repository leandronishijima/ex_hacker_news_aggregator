defmodule HackerNewsAggregator.Core.PaginatorTest do
  use ExUnit.Case, async: true

  alias HackerNewsAggregator.Core.Paginator

  test "when list is empty and page is a negative number" do
    assert %Paginator{valid?: false, list: [], page: 0, total_pages: 0} ==
             Paginator.paginate([], -1)
  end

  test "when list is not empty and page is a negative number" do
    assert %Paginator{valid?: false, list: [], page: 0, total_pages: 0} ==
             Paginator.paginate(1..20, -2)
  end

  test "when list is empty and page is invalid" do
    assert %Paginator{valid?: false, list: [], page: 2, total_pages: 0} ==
             Paginator.paginate([], 2)
  end

  test "when list is empty and page = 1" do
    assert %Paginator{valid?: true, list: [], page: 1, total_pages: 0} ==
             Paginator.paginate([], 1)
  end

  test "when list is nil" do
    assert %Paginator{valid?: false, list: [], page: 1, total_pages: 0} ==
             Paginator.paginate(nil, 1)
  end

  test "when list is not empty" do
    assert %Paginator{valid?: true, list: [1, 2, 3], page: 1, total_pages: 1} ==
             Paginator.paginate(1..3, 1)
  end

  test "when list is not empty and page is invalid" do
    assert %Paginator{valid?: false, list: [], page: 2, total_pages: 1} ==
             Paginator.paginate(1..3, 2)
  end

  test "when list has 20 lenght and page equal 1" do
    assert %Paginator{
             valid?: true,
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
           } == Paginator.paginate(1..20, 1)
  end

  test "when list has 20 lenght and page equal 2" do
    assert %Paginator{
             valid?: true,
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
           } == Paginator.paginate(1..20, 2)
  end

  test "when list has 21 lenght and page equal 3" do
    stories = 1..21

    assert %Paginator{valid?: true, list: [21], page: 3, total_pages: 3} ==
             Paginator.paginate(stories, 3)
  end

  test "when list has 50 lenght and page equal 4" do
    assert %Paginator{
             valid?: true,
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
             Paginator.paginate(1..50, 4)
  end
end
