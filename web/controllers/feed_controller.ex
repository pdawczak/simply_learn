defmodule SL.FeedController do
  use SL.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
