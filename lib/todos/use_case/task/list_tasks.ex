defmodule Todos.UseCase.Task.ListTasks do
  @moduledoc """
  List tasks for a story.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Story.GetStory

  @behaviour Todos.UseCase
  def execute(args) do
    case GetStory.execute(args) do
      {:ok, result} -> list_tasks(result.story.id)
      error -> error
    end
  end

  # Get tasks for a story from the task keeper
  defp list_tasks(story_id) do
    tasks = task_keeper().list_tasks(story_id) |> Enum.map(&Dto.from_schema/1)
    {:ok, %{tasks: tasks}}
  end
end
