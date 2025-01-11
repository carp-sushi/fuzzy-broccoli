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

  # check for required args and get task under story.
  defp get_task(args) do
    case Args.take(args, [:task_id, :story_id]) do
      {:ok, task_id, story_id} -> get_task(task_id, story_id)
      error -> error
    end
  end

  # get task
  defp get_task(task_id, story_id) do
    case task_keeper().get_task(task_id) do
      {:ok, task} -> verify_story(task, story_id)
      {:error, message} -> {:error, "#{message}: #{task_id}", :not_found}
    end
  end

  # Verify the task return from the keeper belongs to the given story.
  defp verify_story(task, story_id) do
    if task.story_id == story_id do
      {:ok, %{task: Dto.from_schema(task)}}
    else
      {:error, "access denied", :forbidden}
    end
  end
end
