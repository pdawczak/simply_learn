defmodule SL.Remote.Data.Book.Upcitemdb do
  @behaviour SL.Remote.Data.BookService

  def get_data(isbn, parent) do
    send parent, do_get_data(isbn)
  end

  defp do_get_data(isbn) do
    isbn
    |> get_content
    |> extract_data
  end

  defp extract_data({:ok, %HTTPoison.Response{status_code: 400}}),
  do: %{}

  defp extract_data({:error, _}),
  do: %{}

  defp extract_data({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Poison.decode
    |> build_map
  end

  defp build_map({:error, _}),
  do: %{}

  defp build_map({:ok, %{"items" => [item | _]}}) do
    %{"title" => title, "images" => images} = item

    %{title:     title,
      image_url: Enum.at(images, 0)}
  end

  defp prepare_isbn(isbn) do
    isbn
    |> to_char_list
    |> Enum.filter(&(&1 != ?-))
    |> to_string
  end

  defp get_content(isbn) do
    isbn
    |> build_url
    |> HTTPoison.get
  end

  defp build_url(isbn) do
    upcitemdb_endpoint <> "?" <> URI.encode_query(%{"upc" => prepare_isbn(isbn)})
  end

  defp upcitemdb_endpoint,
  do: Application.get_env(:simply_learn, :upcitemdb_endpoint)
end
