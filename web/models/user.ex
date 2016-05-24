defmodule SL.User do
  use SL.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :picture_url, :string
    field :auth_client, :string
    field :auth_id, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :picture_url, :auth_client, :auth_id])
    |> validate_required([:first_name, :last_name, :email, :auth_client, :auth_id])
  end

  def find_or_build_for_google(%{"id" => auth_id} = data) do
    criteria = [auth_id:     auth_id,
                auth_client: "google"]

    case SL.Repo.get_by(__MODULE__, criteria) do
      nil  -> build_from_google_data(data)
      user -> user
    end
  end

  defp build_from_google_data(data) do
    %__MODULE__{auth_client: "google",
                auth_id:     data["id"],
                email:       data["email"],
                first_name:  data["given_name"],
                last_name:   data["family_name"],
                picture_url: data["picture"]}
  end
end
