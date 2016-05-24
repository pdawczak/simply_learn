defmodule Auth.Plugs.UserAuthenticated do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3,
                                    redirect: 2]

  def init(default),
  do: default

  def call(%{assigns: %{current_user: user}} = conn, _) when user != nil,
  do: conn

  def call(conn, _) do
    conn
    |> put_flash(:error, "You have to be logged in to access this page")
    |> redirect(to: "/")
    |> halt
  end
end
