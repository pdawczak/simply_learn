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

  def format_description(%{description: nil}),
  do: ""

  def format_description(%Book{description: description}) do
    description
    |> String.split("\n")
    |> Enum.map(&String.strip(&1))
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&content_tag(:p, &1))
  end
end
