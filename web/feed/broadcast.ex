defmodule SL.Feed.Broadcast do
  alias SL.{Endpoint, Feed, FeedView, Repo}
  alias Phoenix.View

  def new_join(%SL.User{id: user_id, first_name: first_name, last_name: last_name}) do
    %Feed{
      title: "New join",
      content: "*#{first_name} #{last_name}* has just joined!",
      user_id: user_id
    }
    |> handle
  end

  def new_book(%SL.Book{title: title}, link, %SL.User{id: user_id}) do
    %Feed{
      title: "New book",
      content: "*#{title}* has been added.",
      link: link,
      user_id: user_id
    }
    |> handle
  end

  def book_borrowed(%SL.Book{title: title}, %SL.User{id: user_id, first_name: first_name, last_name: last_name}) do
    %Feed{
      title: "Book borrowed",
      content: "*#{first_name} #{last_name}* has just borrowed copy of *#{title}*",
      user_id: user_id
    }
    |> handle
  end

  def book_returned(%SL.Book{title: title}, %SL.User{id: user_id, first_name: first_name, last_name: last_name}) do
    %Feed{
      title: "Book returned",
      content: "*#{first_name} #{last_name}* has just returned copy of *#{title}*",
      user_id: user_id
    }
    |> handle
  end

  defp handle(feed) do
    feed_json = View.render(FeedView,
                            "feed.json",
                            %{feed: Repo.insert!(feed)})

    Endpoint.broadcast("feed:lobby", "new_feed", %{feed: feed_json})
  end
end
