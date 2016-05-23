defmodule SL.FeedView do
  use SL.Web, :view

  alias SL.Feed

  def feed_link(%Feed{link: nil}),
  do: ""

  def feed_link(%Feed{link: link}) do
    content_tag :span, class: "pull-right" do
      content_tag :a, href: link do
        "Open"
      end
    end
  end

  def feed_link(_),
  do: ""
end
