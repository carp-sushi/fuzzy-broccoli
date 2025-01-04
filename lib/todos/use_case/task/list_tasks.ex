defmodule Todos.UseCase.Task.ListTasks do
  @moduledoc """
  List tasks for a story.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Story.GetStory

  @behaviour Todos.UseCase
  def execute(args) do
    # Makes sure the story exists, and is owned by the requestor.
    case GetStory.execute(args) do
      {:ok, %{story: story}} -> list_tasks(story.id)
      error -> error
    end
  end

  # Get tasks for a story from the task keeper
  defp list_tasks(story_id) do
    tasks = task_keeper().list_tasks(story_id) |> Enum.map(&Dto.from_schema/1)
    {:ok, %{tasks: tasks}}
  end
end
