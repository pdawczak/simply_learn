defmodule SL.Book do
  use SL.Web, :model

  schema "books" do
    field :title, :string
    field :isbn, :string
    field :image, :string
    field :description, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :isbn, :image, :description])
    |> validate_required([:title, :isbn, :image, :description])
  end
end
