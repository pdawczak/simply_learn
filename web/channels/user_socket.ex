defmodule SL.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "rooms:*", SL.RoomChannel
  channel "feed:lobby", SL.FeedChannel
  channel "borrow_book_copy:*", SL.BorrowBookCopyChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    case verify_token(params, socket) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user, SL.Repo.get(SL.User, user_id))}
      {:error, _reason} ->
        :error
    end
  end

  defp verify_token(%{"token" => token}, socket) do
    Phoenix.Token.verify(socket, "user_id", token, max_age: 1209600)
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     SL.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
