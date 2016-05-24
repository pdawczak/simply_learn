defmodule SL.FeedChannel do
  use SL.Web, :channel
  alias SL.FeedView

  def join("feed:lobby", payload, socket) do
    recent_feeds = SL.Feed.recent

    resp = %{feeds: render_many(recent_feeds)}

    {:ok, resp, socket}
  end

  defp render_many(feeds) do
    Phoenix.View.render_many(feeds, FeedView, "feed.json")
  end
end
