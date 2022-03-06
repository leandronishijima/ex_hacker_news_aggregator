defmodule HackerNewsAggregator.Core.Paginator do
  @moduledoc """
  Module responsible for paginate a list of integers
  """

  defstruct list: [], page: 0, total_pages: 0, valid?: false

  @type paginator :: %__MODULE__{
          valid?: boolean(),
          page: non_neg_integer(),
          total_pages: non_neg_integer(),
          list: list(non_neg_integer())
        }

  @default_pagination 10

  @doc """
  Returns a chunked list in a struct with pagination data, according to the given parameters.

  ## Examples

    iex> Paginator.paginate([], 1) 
    %Paginator{valid?: true, list: [], page: 1, total_pages: 0}

    iex> Paginator.paginate([], 2) 
    %Paginator{valid?: false, list: [], page: 2, total_pages: 0}

    iex> Paginator.paginate([1, 2, 3], 1) 
    %Paginator{valid?: true, list: [1, 2, 3], page: 1, total_pages: 1}

    iex> Paginator.paginate(1..20, 2) 
    %Paginator{valid?: true, list: [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], page: 2, total_pages: 2}
  """
  @spec paginate(list(non_neg_integer()), non_neg_integer()) :: paginator()
  def paginate(nil, page) do
    %__MODULE__{valid?: false, page: page}
  end

  def paginate(_, page) when page <= 0 do
    %__MODULE__{}
  end

  def paginate([], page) do
    cond do
      page > 1 ->
        %__MODULE__{valid?: false, page: page}

      true ->
        %__MODULE__{valid?: true, page: page}
    end
  end

  def paginate(list, page) do
    chuncked_list = Enum.chunk_every(list, @default_pagination)
    paginated_list = Enum.at(chuncked_list, page - 1)

    generate_return(page, paginated_list, chuncked_list)
  end

  defp generate_return(page, paginated_list, chuncked_list)
       when is_nil(paginated_list) do
    %__MODULE__{
      valid?: false,
      page: page,
      total_pages: length(chuncked_list)
    }
  end

  defp generate_return(page, paginated_list, chuncked_list) do
    %__MODULE__{
      valid?: true,
      list: paginated_list,
      page: page,
      total_pages: length(chuncked_list)
    }
  end
end
