defmodule SL.BookCopyController do
  use SL.Web, :controller

  alias SL.{Book, BookCopy}

  def action(conn, _) do
    %{"book_id" => book_id} = conn.params
    book = Book.with_book_copies(book_id)
    apply(__MODULE__,
          action_name(conn),
          [conn, conn.params, book])
  end

  def new(conn, _params, book) do
    changeset =
      book
      |> build_assoc(:book_copies, %{code: prepare_code_proposition(book)})
      |> BookCopy.changeset

    conn
    |> assign(:book, book)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  defp prepare_code_proposition(%{title: title, book_copies: book_copies}) do
    code_str =
      title
      |> to_char_list
      |> Enum.filter(fn c -> c in (?A..?Z) end)
      |> to_string

    code_num =
      book_copies
      |> Enum.count
      |> (fn count -> count + 1 end).()
      |> to_string
      |> String.rjust(4, ?0)

    code_str <> "-" <> code_num
  end

  def create(conn, %{"book_copy" => book_copy_params}, book) do
    changeset =
      book
      |> build_assoc(:book_copies)
      |> BookCopy.changeset(book_copy_params)

    case Repo.insert(changeset) do
      {:ok, _book_copy} ->
        conn
        |> put_flash(:info, "Book copy added successfully.")
        |> redirect(to: book_path(conn, :show, book))
      {:error, changeset} ->
        conn
        |> assign(:book, book)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def delete(conn, %{"id" => id}, book) do
    book_copy =
      book
      |> assoc(:book_copies)
      |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(book_copy)

    conn
    |> put_flash(:info, "Book copy deleted successfully.")
    |> redirect(to: book_path(conn, :index))
  end
end
