defmodule SL.Remote.Data.Book.UpcitemdbTest do
  use ExUnit.Case

  alias SL.Remote.Data.Book.Upcitemdb

  setup do
    bypass = Bypass.open

    Application.put_env(:simply_learn, :upcitemdb_endpoint, "http://localhost:#{bypass.port}/")

    {:ok, bypass: bypass}
  end

  test "fetches data from server", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "upc=123456789" == conn.query_string
      Plug.Conn.resp(conn, 200, ~s<{"items": [{"title": "Sample Book", "images": ["http://pic.com/sample.png"]}]}>)
    end

    Upcitemdb.get_data("123-456-789", self())

    assert_received %{title: "Sample Book", image_url: "http://pic.com/sample.png"}
  end

  test "builds empty map if no results found", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 400, ~s<{"code": "INVALID_UPC"}>)
    end

    Upcitemdb.get_data("123-456-789", self())

    assert_received %{}
  end

  test "handles item with no images", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"items": [{"title": "Just Book", "images": []}]}>)
    end

    Upcitemdb.get_data("123-456-789", self())

    assert_received %{title: "Just Book", image_url: nil}
  end

  test "builds empty map if it can't access endpoint", %{bypass: bypass} do
    Bypass.down(bypass)

    Upcitemdb.get_data("123-456-789", self())

    assert_received %{}
  end
end
