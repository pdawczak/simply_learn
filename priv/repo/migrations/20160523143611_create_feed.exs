defmodule SL.Repo.Migrations.CreateFeed do
  use Ecto.Migration

  def change do
    create table(:feeds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :link, :string

      timestamps
    end

  end
end
