defmodule SL.Repo.Migrations.CreateBorrowing do
  use Ecto.Migration

  def change do
    create table(:borrowings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :started_at, :datetime
      add :ended_at, :datetime
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :book_copy_id, references(:book_copies, on_delete: :nothing, type: :binary_id)

      timestamps
    end

    create index(:borrowings, [:user_id])
    create index(:borrowings, [:book_copy_id])
  end
end
