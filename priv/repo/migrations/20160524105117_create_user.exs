defmodule SL.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :picture_url, :string
      add :auth_client, :string
      add :auth_id, :string

      timestamps
    end

  end
end
