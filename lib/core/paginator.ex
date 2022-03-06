defmodule HackerNewsAggregator.Core.Paginator do
  defstruct list: [], page: 0, total_pages: 0, valid?: false

  def paginate(nil, page) do
    %__MODULE__{valid?: false, page: page}
  end

  def paginate([], page) when page > 1 do
    %__MODULE__{valid?: false, page: page}
  end

  def paginate([], page) do
    %__MODULE__{valid?: true, page: page}
  end

  def paginate(list, page) do
    chuncked_list = Enum.chunk_every(list, 10)

    paginated_list = Enum.at(chuncked_list, page - 1)

    if is_nil(paginated_list) do
      %__MODULE__{
        valid?: false,
        list: [],
        page: page,
        total_pages: length(chuncked_list)
      }
    else
      %__MODULE__{
        valid?: true,
        list: paginated_list,
        page: page,
        total_pages: length(chuncked_list)
      }
    end
  end
end
