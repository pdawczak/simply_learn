defmodule SL.Feed.Broadcast do
  alias SL.{Endpoint, Feed, FeedView, Repo}
  alias Phoenix.View

  def new_join(%SL.User{first_name: first_name, last_name: last_name}) do
    %Feed{
      title: "New join",
      content: "*#{first_name} #{last_name}* has just joined!"
    }
    |> handle
  end

  def new_book(book = %SL.Book{title: title}, link) do
    %Feed{
      title: "New book",
      content: "*#{title}* has been added.",
      link: link
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
