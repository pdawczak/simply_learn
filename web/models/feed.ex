defmodule SL.Feed do
  use SL.Web, :model

  schema "feeds" do
    field :title, :string
    field :content, :string
    field :link, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :link])
    |> validate_required([:title, :content])
  end

  def recent(opts \\ []) do
    limit = opts[:limit] || 10

    q = from f in SL.Feed,
      order_by: [desc: f.inserted_at],
      limit: ^limit

    SL.Repo.all(q)
  end
end
