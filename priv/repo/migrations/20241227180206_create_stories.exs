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
    create constraint(:stories, :story_name_length, check: "char_length(name) <= 100")
    create constraint(:stories, :story_description_length, check: "char_length(description) <= 1000")
  end
end
