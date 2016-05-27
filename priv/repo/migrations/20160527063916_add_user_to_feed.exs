defmodule SL.Repo.Migrations.AddUserToFeed do
  use Ecto.Migration

  def change do
    alter table(:feeds) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
    end

    create index(:feeds, [:user_id])
  end
end
