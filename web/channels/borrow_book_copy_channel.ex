defmodule SL.BorrowBookCopyChannel do
  use SL.Web, :channel

  def join("borrow_book_copy:" <> id, _payload, socket) do
    book_copy =
      SL.BookCopy
      |> Repo.get(id)
      |> Repo.preload(:book)

    {:ok,
     %{status: borrowing_status(book_copy)},
     assign(socket, :book_copy, book_copy)}
  end

  def handle_in(event, params, socket) do
    handle_in(event,
              params,
              socket.assigns.book_copy,
              socket.assigns.user,
              socket)
  end

  def handle_in("borrow", _params, book_copy, user, socket) do
    new_borrowing =
      book_copy
      |> build_assoc(:borrowings, %{started_at: Ecto.DateTime.utc,
                                    user_id: user.id})
      |> Repo.insert!

    broadcast_book_borrowed(book_copy.book, user)

    broadcast socket, "borrowing_updated", borrowing_status(book_copy)

    {:reply, :ok, socket}
  end

  defp broadcast_book_borrowed(book, user) do
    feed =
      %SL.Feed{
        title: "Book borrowed",
        content: "*#{user.first_name} #{user.last_name}* has just borrowed copy of *#{book.title}*",
      }
      |> Repo.insert!

    feed_json = Phoenix.View.render(SL.FeedView, "feed.json", %{feed: feed})

    SL.Endpoint.broadcast("feed:lobby", "new_feed", %{feed: feed_json})
  end

  def handle_in("return", _params, book_copy, user, socket) do
    borrowing =
      book_copy
      |> last_borrowing
      |> SL.Borrowing.changeset(%{ended_at: Ecto.DateTime.utc})
      |> Repo.update!

    broadcast_book_returned(book_copy.book, user)

    broadcast socket, "borrowing_updated", borrowing_status(book_copy)

    {:reply, :ok, socket}
  end

  defp broadcast_book_returned(book, user) do
    feed =
      %SL.Feed{
        title: "Book returned",
        content: "*#{user.first_name} #{user.last_name}* has just returned copy of *#{book.title}*",
      }
      |> Repo.insert!

    feed_json = Phoenix.View.render(SL.FeedView, "feed.json", %{feed: feed})

    SL.Endpoint.broadcast("feed:lobby", "new_feed", %{feed: feed_json})
  end

  defp borrowing_status(book_copy) do
    case last_borrowing(book_copy) do
      nil ->
        %{available: true}
      %{ended_at: ended_at} when ended_at != nil ->
        %{available: true}
      %{user: user} ->
        %{available: false, borrowed_by: %{user_id: user.id, first_name: user.first_name, last_name: user.last_name}}
    end
  end

  defp last_borrowing(book_copy) do
    Repo.one(
      from br in assoc(book_copy, :borrowings),
      order_by: [desc: br.started_at],
      preload: [:user],
      limit: 1
    )
  end
end
