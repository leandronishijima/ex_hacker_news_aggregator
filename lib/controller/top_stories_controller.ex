defmodule HackerNewsAggregator.Controller.TopStoriesController do
  import Plug.Conn

  alias HackerNewsAggregator.Core

  def get_top_stories(conn, core \\ Core)

  def get_top_stories(%{params: %{"page" => page}} = conn, core) do
    case Integer.parse(page) do
      {parsed_page, _} ->
        new_params = Map.update(conn.params, "page", parsed_page, fn _ -> parsed_page end)
        response_json = Core.get_paginate_top_stories(core, new_params)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, response_json)

      :error ->
        send_invalid_parameter(conn)
    end
  end

  def get_top_stories(conn, _core), do: send_invalid_parameter(conn)

  defp send_invalid_parameter(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, "Page parameter invalid")
  end
end
