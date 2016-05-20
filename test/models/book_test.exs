defmodule SL.BookTest do
  use SL.ModelCase
  import SL.Factory

  alias SL.Book

  test "changeset with valid attributes" do
    changeset = Book.changeset(%Book{}, fields_for(:book))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Book.changeset(%Book{}, fields_for(:book, title: nil))
    refute changeset.valid?
  end
end
