defmodule Todos.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories, primary_key: false) do
      add :id, :string, size: 21, primary_key: true
      add :blockchain_address, :text, null: false
      add :name, :text, null: false
      add :description, :text
      add :deleted_at, :timestamp
      timestamps()
    end
    create index(:stories, [:blockchain_address])
  end
end
