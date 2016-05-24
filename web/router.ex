defmodule SL.Router do
  use SL.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SL do
    pipe_through :browser # Use the default browser stack

    get "/", FeedController, :index
    get "/books/start-new", BookController, :start_new
    resources "/books", BookController do
      resources "/book_copies", BookCopyController, only: [:new, :create, :delete]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SL do
  #   pipe_through :api
  # end
end
