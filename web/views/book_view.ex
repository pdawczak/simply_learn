defmodule SL.BookView do
  use SL.Web, :view

  alias SL.Book

  def intro(book = %Book{description: description})
      when byte_size(description) > 0
  do
    book
    |> format_description
    |> List.first
    |> ensure_length(600)
  end

  defp ensure_length({:safe, [_, description, _]}, max_length) do
    case byte_size(description) > max_length do
      true ->
        description
        |> String.slice(0, max_length)
        |> (fn text -> text <> "..." end).()
      false ->
        description
    end
  end

  def intro(_),
  do: ""

  def format_description(%Book{description: nil}),
  do: ""

  def format_description(%Book{description: description}) do
    description
    |> String.split("\n")
    |> Enum.map(&String.strip(&1))
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&content_tag(:p, &1))
  end
end
