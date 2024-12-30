defmodule Todos.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :string, size: 21, primary_key: true
      add :story_id, references(:stories, type: :string), size: 21, null: false
      add :name, :text, null: false
      add :status, :text, null: false
      add :deleted_at, :timestamp
      timestamps()
    end
    create index(:tasks, [:story_id])
  end
end
