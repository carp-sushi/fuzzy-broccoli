defmodule Mix.Tasks.Migrate do
  @moduledoc """
  A custom mix task that runs ecto migrations.
  """
  use Mix.Task
  require Application

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:todos)
    path = Application.app_dir(:todos, "priv/repo/migrations")
    Ecto.Migrator.run(Todos.Repo, path, :up, all: true)
    :init.stop()
  end
end
