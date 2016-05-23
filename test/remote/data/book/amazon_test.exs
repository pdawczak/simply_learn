defmodule SL.Remote.Data.Book.AmazonTest do
  use ExUnit.Case

  alias SL.Remote.Data.Book.Amazon

  setup do
    bypass = Bypass.open

    Application.put_env(:simply_learn, :amazon_search_endpoint, "http://localhost:#{bypass.port}/")

    {:ok, bypass: bypass}
  end

  test "fetches data from server", %{bypass: bypass} do
    search_result_html = """
      <div id="s-results-list-atf">
        <div id="result_0">
          <a class="s-access-detail-page"
             href="http://localhost:#{bypass.port}/book_details">
            Details Page
          </a>
        </div>
      </div>
    """
    details_page = """
      <div id="bookDescription_feature_div">
        <noscript>
          <div>
            Example Description
          </div>
        </noscript>
      </div>
    """
    Bypass.expect bypass, fn conn ->
      case conn.request_path do
        "/book_details" ->
          Plug.Conn.resp(conn, 200, details_page)
        _ ->
          Plug.Conn.resp(conn, 200, search_result_html)
      end
    end

    Amazon.get_data("123-456-789", self())

    assert_received %{description: "Example Description"}
  end

  test "builds empty map if no results found in amazon", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s|<h2>No Results!</h2>|)
    end

    Amazon.get_data("123-456-789", self())

    assert_received %{}
  end

  test "builds empty map if can't access amazon", %{bypass: bypass} do
    Bypass.down(bypass)

    Amazon.get_data("123-456-789", self())

    assert_received %{}
  end
end
