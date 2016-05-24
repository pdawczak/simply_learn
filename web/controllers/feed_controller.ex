defmodule SL.FeedController do
  use SL.Web, :controller

  def index(%{assigns: %{current_user: user}} = conn, _params) when user != nil do
    conn
    |> render("index.html")
  end

  def index(conn, _params) do
    conn
    |> put_layout("app_with_no_navigation.html")
    |> render("non_authenticated_index.html")
  end
end
