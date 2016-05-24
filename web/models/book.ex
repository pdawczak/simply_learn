defmodule SL.Book do
  use SL.Web, :model

  schema "books" do
    field :title, :string
    field :isbn, :string
    field :image_url, :string
    field :description, :string

    has_many :book_copies, SL.BookCopy

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :isbn, :image_url, :description])
    |> validate_required([:title, :isbn, :description])
    |> unique_constraint(:isbn, name: :books_isbn_index)
  end

  def with_book_copies(id) do
    q = from b in SL.Book,
      where: b.id == ^id,
      preload: [:book_copies]
    SL.Repo.one(q)
  end
end
