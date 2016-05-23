defmodule SL.BookController do
  use SL.Web, :controller

  alias SL.Book

  def index(conn, _params) do
    books = Repo.all(Book)
    render(conn, "index.html", books: books)
  end

  def start_new(conn, _params) do
    render(conn, "start_new.html")
  end

  def new(conn, %{"isbn" => isbn}) do
    changeset =
      SL.Remote.Data.Book.get_data(isbn, %Book{isbn: isbn})
      |> Book.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Book.changeset(%Book{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    changeset = Book.changeset(%Book{}, book_params)

    case Repo.insert(changeset) do
      {:ok, book} ->
        conn
        |> create_new_book_feed(book)
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: book_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp create_new_book_feed(conn, book) do
    feed =
      %SL.Feed{
        title: "New book",
        content: "*#{book.title}* has been added.",
        link: book_path(conn, :show, book)
      }

    Repo.insert(feed)

    conn
  end

  def show(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)
    changeset = Book.changeset(book)
    render(conn, "edit.html", book: book, changeset: changeset)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Repo.get!(Book, id)
    changeset = Book.changeset(book, book_params)

    case Repo.update(changeset) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: book_path(conn, :show, book))
      {:error, changeset} ->
        render(conn, "edit.html", book: book, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: book_path(conn, :index))
  end
end
