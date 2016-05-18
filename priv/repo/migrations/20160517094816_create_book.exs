defmodule SL.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :isbn, :string
      add :image, :string
      add :description, :text

      timestamps
    end

  end
end
