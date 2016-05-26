defmodule SL.AuthController do
  use SL.Web, :controller
  require Logger

  alias Auth.OAuth2.Google
  alias SL.User

  def index(conn, _params) do
    redirect(conn, external: Google.authorize_url)
  end

  def new(conn, %{"code" => code}) do
    case Google.get_user_data(code) do
      {:error, error_response} -> handle_oauth_error(conn, error_response)
      {:ok,    user_data}      -> handle_oauth_success(conn, User.find_or_build_for_google(user_data))
    end
  end

  def new(conn, error_response = %{"error" => _error}) do
    handle_oauth_error(conn, error_response)
  end

  def delete(conn, _params) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "You've been logged out successfully!")
    |> redirect(to: feed_path(conn, :index))
  end

  defp handle_oauth_success(conn, %User{id: nil} = non_persisted_user) do
    user = Repo.insert!(non_persisted_user)

    SL.Feed.Broadcast.new_join(user)

    conn
    |> put_session(:user_id, user.id)
    |> put_flash(:info, "Hi #{user.first_name}, nice to have you on board!")
    |> redirect(to: feed_path(conn, :index))
  end

  defp handle_oauth_success(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> put_flash(:info, "Hi #{user.first_name}, you've been authenticated successfully!")
    |> redirect(to: feed_path(conn, :index))
  end

  defp handle_oauth_error(conn, error_response) do
    Logger.error("OAuth error: #{inspect error_response}")

    conn
    |> put_flash(:error, "Authentication failed!")
    |> put_layout("app_with_no_navigation.html")
    |> render("new_error.html")
  end
end
