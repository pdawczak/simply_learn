defmodule SL.FeedView do
  use SL.Web, :view

  def render("feed.json", %{feed: feed}) do
    %{id:          feed.id,
      content:     feed.content,
      title:       feed.title,
      link:        feed.link,
      user:        %{first_name:  feed.user.first_name,
                     last_name:   feed.user.last_name,
                     picture_url: feed.user.picture_url},
      inserted_at: feed.inserted_at}
  end
end
