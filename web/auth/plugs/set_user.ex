defmodule Auth.Plugs.SetUser do
  import Plug.Conn

  def init(defaults),
  do: defaults

  def call(conn, _) do
    case get_session(conn, :user_id) do
      nil -> conn
      id  -> assign(conn, :current_user, SL.Repo.get(SL.User, id))
    end
  end
end
