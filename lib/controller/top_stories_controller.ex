defmodule HackerNewsAggregator.Controller.TopStoriesController do
  @moduledoc """
  Module controller responsible to receive http connections and return 
  top stories from the Agent.
  """

  import Plug.Conn

  alias HackerNewsAggregator.Core

  @doc """
  Return %Plug.Conn{} with top stories paginated in json format.
  """
  @spec get_top_stories(%Plug.Conn{params: %{required(String.t()) => String.t()}}) ::
          %Plug.Conn{}
  def get_top_stories(conn)

  def get_top_stories(%{params: %{"page" => page}} = conn) do
    case Integer.parse(page) do
      {parsed_page, _} ->
        new_params = Map.update(conn.params, "page", parsed_page, fn _ -> parsed_page end)

        response_json = Core.get_paginate_top_stories(new_params)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, response_json)

      :error ->
        send_invalid_parameter(conn)
    end
  end

  def get_top_stories(conn), do: send_invalid_parameter(conn)

  defp send_invalid_parameter(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, "Page parameter invalid")
  end
end
