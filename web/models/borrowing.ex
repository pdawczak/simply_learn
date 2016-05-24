defmodule SL.Borrowing do
  use SL.Web, :model

  schema "borrowings" do
    field :started_at, Ecto.DateTime
    field :ended_at, Ecto.DateTime
    belongs_to :user, SL.User
    belongs_to :book_copy, SL.BookCopy

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:started_at, :ended_at])
    |> validate_required([:started_at])
  end
end
