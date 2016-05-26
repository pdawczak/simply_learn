defmodule Auth.Plugs.SetUser do
  import Plug.Conn

  def init(defaults),
  do: defaults

  def call(conn, _) do
    case get_session(conn, :user_id) do
      nil -> conn
      id  ->
        conn
        |> assign(:current_user, SL.Repo.get(SL.User, id))
        |> assign(:user_token, Phoenix.Token.sign(conn, "user_id", id))
    end
  end
end
