defmodule Todos.UseCase.Task.UpdateTask do
  @moduledoc """
  Update a task.
  """
  use Todos.Data.Keeper

  alias Todos.Data.Schema.Task
  alias Todos.Dto
  alias Todos.UseCase.Task.GetTask

  @behaviour Todos.UseCase
  def execute(args) do
    case GetTask.execute(args) do
      {:ok, %{task: task}} -> args |> unpack_updates(task) |> update_task(task)
      error -> error
    end
  end

  # Unpack any updates, falling back to existing values.
  defp unpack_updates(args, task) do
    %{
      name: Map.get(args, :name) || task.name,
      status: Map.get(args, :status) || task.status
    }
  end

  defp update_task(updates, task) do
    task
    |> to_schema()
    |> task_keeper().update_task(updates)
    |> case do
      {:ok, task} -> {:ok, %{task: Dto.from_schema(task)}}
      {:error, error} -> {:invalid_args, error}
    end
  end

  # Create a skeleton task schema struct.
  defp to_schema(data),
    do: %Task{
      id: data.id,
      story_id: data.story_id
    }
end
