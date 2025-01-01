defmodule Todos.Data.Repo.TaskRepo do
  @moduledoc """
  Data repo (concrete keeper) for managing tasks.
  """
  @behaviour Todos.Data.Keeper.TaskKeeper

  alias Todos.Data.Schema.Task
  alias Todos.{Error, Repo}
  alias Todos.Util.Clock

  import Ecto.Query

  # Sets a maximum on query result size.
  @max_records Application.compile_env(:todos, :max_records)

  @doc "Create a new task."
  def create_task(params) do
    %Task{}
    |> Task.changeset(params)
    |> Repo.insert()
    |> case do
      {:error, cs} -> {:error, Error.extract(cs)}
      result -> result
    end
  end

  @doc "Get a task"
  def get_task(id) do
    Repo.one(
      from(t in Task,
        where: t.id == ^id and is_nil(t.deleted_at),
        select: t
      )
    )
    |> case do
      nil -> {:error, "task not found: #{id}"}
      task -> {:ok, task}
    end
  end

  @doc "Get tasks for a story."
  def list_tasks(story_id) do
    Repo.all(
      from(t in Task,
        where: t.story_id == ^story_id and is_nil(t.deleted_at),
        order_by: [asc: t.inserted_at],
        limit: @max_records,
        select: t
      )
    )
  end

  @doc "Update a task."
  def update_task(struct, params) do
    struct
    |> Task.changeset(params)
    |> Repo.update()
    |> case do
      {:error, cs} -> {:error, Error.extract(cs)}
      result -> result
    end
  end

  @doc "Delete a task."
  def delete_task(id) do
    update_all(
      from(t in Task,
        where: t.id == ^id and is_nil(t.deleted_at),
        update: [set: [deleted_at: ^Clock.now()]]
      )
    )
  end

  # Helper for readability
  defp update_all(queryable),
    do: queryable |> Repo.update_all([])
end
