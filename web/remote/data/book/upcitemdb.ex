defmodule SL.Remote.Data.Book.Upcitemdb do
  @behaviour SL.Remote.Data.BookService

  def get_data(isbn, parent) do
    send parent, do_get_data(isbn)
  end

  defp do_get_data(isbn) do
    case get_content(upcitemdb_endpoint <> "?" <> URI.encode_query(%{"upc" => prepare_isbn(isbn)})) do
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        %{}

      {:ok, %HTTPoison.Response{body: body}} ->
        decoded = Poison.decode!(body)
        case Enum.at(decoded["items"], 0) do
          %{"title" => title, "images" => images} ->
            %{title: title,
              image_url: Enum.at(images, 0)}
          _ ->
            %{}
        end

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

  defp upcitemdb_endpoint,
  do: Application.get_env(:simply_learn, :upcitemdb_endpoint)
end
