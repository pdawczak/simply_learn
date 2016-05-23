defmodule SL.BookView do
  use SL.Web, :view

  alias SL.Book

  def shorter_description(%Book{description: nil}),
  do: ""

  @length 250
  def shorter_description(%Book{description: description}) when byte_size(description) > @length,
  do: String.slice(description, 0, @length) <> "..."

  def shorter_description(%Book{description: description}),
  do: description
end
