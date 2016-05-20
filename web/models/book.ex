defmodule SL.Book do
  use SL.Web, :model

  schema "books" do
    field :title, :string
    field :isbn, :string
    field :image_url, :string
    field :description, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :isbn, :image_url, :description])
    |> validate_required([:title, :isbn, :image_url, :description])
  end
end
