defmodule Auth.OAuth2.Google do
  use OAuth2.Strategy

  alias OAuth2.{AccessToken, Client, Strategy.AuthCode}

  defp config do
    [strategy:      AuthCode,
     site:          "https://accounts.google.com",
     authorize_url: "/o/oauth2/auth",
     token_url:     "/o/oauth2/token",
     redirect_uri:  "http://localhost:4000/auth/google",]
  end

  defp client do
    Application.get_env(:oauth2, Google)
    |> Keyword.merge(config)
    |> Client.new
  end

  def authorize_url do
    Client.authorize_url!(client, scope: "profile email")
  end

  def get_user_data(code) do
    request_user_data(code)
  end

  @user_data_url "https://www.googleapis.com/oauth2/v2/userinfo"
  defp request_user_data(code) do
    case Client.get_token(client, code: code) do
      {:ok, token} ->
        {:ok, %{body: body}} = AccessToken.get(token, @user_data_url)
        handle_body(body)
      {:error, %OAuth2.Error{reason: reason}} ->
        {:error, message: "Something went wrong", reason: to_string(reason)}
    end
  end

  defp handle_body(%{"error" => %{"errors" => [error | _t]}}) do
    %{"message" => message, "reason"  => reason} = error
    {:error, message: message, reason: reason}
  end

  defp handle_body(user_data), do: {:ok, user_data}
end
