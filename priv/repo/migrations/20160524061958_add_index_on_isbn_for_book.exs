defmodule SL.Repo.Migrations.AddIndexOnIsbnForBook do
  use Ecto.Migration

  def change do
    create unique_index(:books, [:isbn])
  end
end
