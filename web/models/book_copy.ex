defmodule SL.BookCopy do
  use SL.Web, :model

  schema "book_copies" do
    field :code, :string

    belongs_to :book, SL.Book
    has_many :borrowings, SL.Borrowing

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code])
    |> validate_required([:code])
  end
end
