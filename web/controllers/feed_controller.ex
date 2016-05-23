defmodule SL.FeedController do
  use SL.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:feeds, SL.Feed.recent)
    |> render("index.html")
  end
end
