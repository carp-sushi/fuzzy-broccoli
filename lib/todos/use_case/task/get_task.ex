defmodule Todos.UseCase.Task.GetTask do
  @moduledoc """
  Get a task.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Args
  alias Todos.UseCase.Story.GetStory

  @behaviour Todos.UseCase
  def execute(args) do
    case GetStory.execute(args) do
      {:ok, _} -> get_task(args)
      error -> error
    end
  end

  # Get task
  defp get_task(args) do
    Args.validate(args, [:task_id], fn ->
      case task_keeper().get_task(args.task_id) do
        {:ok, task} -> verify_story(task, args.story_id)
        {:error, error} -> {:not_found, error}
      end
    end)
  end

  # Ensure the task return from the keeper belongs to the given story.
  defp verify_story(task, story_id) do
    case task.story_id == story_id do
      true -> {:ok, %{task: Dto.from_schema(task)}}
      false -> {:not_found, "task not found: #{task.id}"}
    end
  end
end
