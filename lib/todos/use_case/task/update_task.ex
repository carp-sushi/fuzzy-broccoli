defmodule Todos.UseCase.Task.UpdateTask do
  @moduledoc """
  Update a task.
  """
  alias Todos.Dto
  use Todos.Data.Keeper
  alias Todos.UseCase.Task.GetTask

  @behaviour Todos.UseCase
  def execute(args) do
    case GetTask.execute(args) do
      {:ok, %{task: task}} -> update_task(task, args)
      error -> error
    end
  end

  defp update_task(task, args) do
    case task_keeper().update_task(schema(task), unpack_updates(task, args)) do
      {:ok, task} -> {:ok, %{task: Dto.from_schema(task)}}
      {:error, error} -> {:invalid_args, error}
    end
  end

  # Unpack any updates, falling back to existing values.
  defp unpack_updates(task, args) do
    %{
      name: Map.get(args, :name) || task.name,
      status: Map.get(args, :status) || task.status
    }
  end

  # Create a skeleton task schema struct.
  defp schema(task) do
    %Todos.Data.Schema.Task{id: task.id, story_id: task.story_id}
  end
end
