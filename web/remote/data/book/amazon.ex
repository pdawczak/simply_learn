defmodule SL.Remote.Data.Book.Amazon do
  @behaviour SL.Remote.Data.BookService

  def get_data(isbn, parent) do
    send parent, do_get_data(isbn)
  end

  defp do_get_data(isbn) do
    isbn
    |> build_search_url
    |> get_content
    |> fetch_first_results_href
    |> get_content
    |> extract_data
  end

  defp build_search_url(isbn) do
    amazon_search_endpoint <> "?url=search-alias%3Dstripbooks&field-keywords=" <> isbn
  end

  defp fetch_first_results_href({:error, _}),
  do: nil

  defp fetch_first_results_href({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Floki.find("#s-results-list-atf #result_0 .s-access-detail-page")
    |> Floki.attribute("href")
    |> Enum.at(0)
  end

  defp get_content(nil),
  do: {:error, :no_url}

  defp get_content(url),
  do: HTTPoison.get(url)

  defp extract_data({:error, _}),
  do: %{}

  defp extract_data({:ok, %HTTPoison.Response{body: body}}) do
    description =
      body
      |> Floki.find("#bookDescription_feature_div noscript div")
      |> Floki.text

    %{description: String.strip(description)}
  end

  defp amazon_search_endpoint,
  do: Application.get_env(:simply_learn, :amazon_search_endpoint)
end
