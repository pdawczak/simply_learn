defmodule SL.FeedChannelTest do
  use SL.ChannelCase

  alias SL.FeedChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(FeedChannel, "feed:lobby")

    {:ok, socket: socket}
  end
end
