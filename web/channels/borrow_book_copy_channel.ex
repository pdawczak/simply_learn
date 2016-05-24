defmodule SL.BorrowBookCopyChannel do
  use SL.Web, :channel

  def join("borrow_book_copy:" <> id, payload, socket) do
    socket = verify_token(payload, socket)

    if authorised?(socket) do
      {:ok, %{authorised_with: socket.assigns.user_id}, socket}
    else
      {:error, %{reason: "unauthorised"}}
    end
  end

  defp authorised?(%{assigns: %{user_id: user_id}}) when user_id != nil,
  do: true

  defp authorised?(_socket),
  do: false

  defp verify_token(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user_id", token, max_age: 1209600) do
      {:ok, user_id} ->
        assign(socket, :user_id, user_id)
      {:error, _} ->
        socket
    end
  end
end
