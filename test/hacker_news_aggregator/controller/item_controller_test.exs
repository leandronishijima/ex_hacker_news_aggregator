defmodule HackerNewsAggregator.Controller.ItemControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox

  alias Plug.Conn
  alias HackerNewsAggregator.Controller.ItemController

  setup :verify_on_exit!

  describe "item/1" do
    test "when the item id exists in api" do
      HackerNewsAggregator.HackerNews.MockApi
      |> expect(:item, fn _item_id ->
        {:ok,
         %{
           "by" => "ny_entrepreneur",
           "id" => 3_029_946,
           "parent" => 3_028_322,
           "text" => "text from item",
           "kids" => [30_293_946, 30_294_081, 30_294_010, 30_295_007],
           "time" => 1_316_785_698,
           "type" => "comment"
         }}
      end)

      item_id = "3029946"
      conn = conn(:get, "/item/#{item_id}")

      assert %Conn{
               state: :sent,
               status: 200,
               resp_body:
                 "{\"by\":\"ny_entrepreneur\",\"id\":3029946,\"kids\":[30293946,30294081,30294010,30295007],\"parent\":3028322,\"text\":\"text from item\",\"time\":1316785698,\"type\":\"comment\"}"
             } = ItemController.get_item(conn, item_id)
    end

    test "when the item id is invalid" do
      item_id = "invalid_id"
      conn = conn(:get, "/item/#{item_id}")

      assert %Conn{
               state: :sent,
               status: 400,
               resp_body: "Id parameter is invalid"
             } = ItemController.get_item(conn, item_id)
    end

    test "when the item id doesnt exist" do
      HackerNewsAggregator.HackerNews.MockApi
      |> expect(:item, fn _item_id ->
        {:ok, nil}
      end)

      item_id = "3029946"
      conn = conn(:get, "/item/#{item_id}")

      assert %Conn{
               state: :sent,
               status: 404,
               resp_body: "Item not found"
             } = ItemController.get_item(conn, item_id)
    end
  end
end
