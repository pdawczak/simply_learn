defmodule SL.FeedView do
  use SL.Web, :view

  alias SL.Feed

  def render("feed.json", %{feed: feed}) do
    %{id:          feed.id,
      content:     feed.content,
      title:       feed.title,
      link:        feed.link,
      inserted_at: feed.inserted_at}
  end
end
