defmodule SL.Factory do
  use ExMachina.Ecto, repo: SL.Repo

  alias SL.Book

  def factory(:book) do
    %Book{
      title:       "Refactoring",
      isbn:        "123-12345678-9-0",
      image_url:   "http://sample.com/my-image.png",
      description: "Sample description"
    }
  end
end
