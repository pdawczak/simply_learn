defmodule SL.BookControllerTest do
  use SL.ConnCase
  import SL.Factory

  alias SL.Book

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, book_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing books"
  end

  test "lets you start adding new book by providing ISBN", %{conn: conn} do
    conn = get conn, book_path(conn, :start_new)
    assert html_response(conn, 200) =~ "ISBN"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, book_path(conn, :new)
    assert html_response(conn, 200) =~ "New book"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, book_path(conn, :create), book: fields_for(:book, title: "The Book")
    assert redirected_to(conn) == book_path(conn, :index)
    assert Repo.get_by(Book, title: "The Book")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, book_path(conn, :create), book: fields_for(:book, title: nil)
    assert html_response(conn, 200) =~ "New book"
  end

  test "shows chosen resource", %{conn: conn} do
    book = create(:book, title: "Sample book")
    conn = get conn, book_path(conn, :show, book)
    assert html_response(conn, 200) =~ "Sample book"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, book_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    book = create(:book)
    conn = get conn, book_path(conn, :edit, book)
    assert html_response(conn, 200) =~ "Edit book"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    book = create(:book, title: "Sample Book")
    conn = put conn, book_path(conn, :update, book), book: %{title: "The Book"}
    assert redirected_to(conn) == book_path(conn, :show, book)
    assert Repo.get_by(Book, title: "The Book")
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    book = create(:book)
    conn = put conn, book_path(conn, :update, book), book: fields_for(:book, title: nil)
    assert html_response(conn, 200) =~ "Edit book"
  end

  test "deletes chosen resource", %{conn: conn} do
    book = create(:book)
    conn = delete conn, book_path(conn, :delete, book)
    assert redirected_to(conn) == book_path(conn, :index)
    refute Repo.get(Book, book.id)
  end
end
