defmodule SL.Remote.Data.Book.Amazon do
  @behaviour SL.Remote.Data.BookService

  def get_data(isbn, parent) do
    send parent, do_get_data(isbn)
  end

  defp do_get_data(isbn) do
    case perform_search(isbn) do
      {:ok, %HTTPoison.Response{body: body}} ->
        details_page_url =
          Floki.find(body, "#s-results-list-atf #result_0 .s-access-detail-page")
          |> Floki.attribute("href")
          |> Enum.at(0)

        case obtain_content_for(details_page_url) do
          {:ok, %HTTPoison.Response{body: body}} ->
            description =
              Floki.find(body, "#bookDescription_feature_div noscript div")
              |> Floki.text

            %{description: description}

          {:error, _response} ->
            %{}
        end

      {:error, _respone} ->
        %{}
    end
  end

  def perform_search(isbn) do
    HTTPoison.get("https://www.amazon.co.uk/s/ref=nb_sb_noss?url=search-alias%3Dstripbooks&field-keywords=" <> isbn)
  end

  def obtain_content_for(nil) do
    {:error, "No url :("}
  end

  def obtain_content_for(url) do
    HTTPoison.get(url)
  end
end
