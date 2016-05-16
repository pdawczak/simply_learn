defmodule SL.PageController do
  use SL.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
