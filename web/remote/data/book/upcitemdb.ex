defmodule SL.Remote.Data.Book.Upcitemdb do
  @behaviour SL.Remote.Data.BookService

  def get_data(isbn, parent) do
    send parent, do_get_data(isbn)
  end

  defp do_get_data(isbn) do
    case get_content("https://api.upcitemdb.com/prod/trial/lookup?upc=" <> prepare_isbn(isbn)) do
      {:ok, %HTTPoison.Response{body: body}} ->
        decoded = Poison.decode!(body)
        item = Enum.at(decoded["items"], 0)

        %{title: item["title"],
          image_url: Enum.at(item["images"], 0)}

      {:error, _response} ->
        %{}
    end
  end

  defp prepare_isbn(isbn) do
    isbn
    |> to_char_list
    |> Enum.filter(fn c -> c != ?- end)
    |> to_string
  end

  defp get_content(url) do
    HTTPoison.get(url)
  end
end
