defmodule SL.Repo.Migrations.CreateBookCopy do
  use Ecto.Migration

  def change do
    create table(:book_copies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :code, :string
      add :book_id, references(:books, on_delete: :nothing, type: :binary_id)

      timestamps
    end

    create index(:book_copies, [:book_id])
    create unique_index(:book_copies, [:code])
  end
end
