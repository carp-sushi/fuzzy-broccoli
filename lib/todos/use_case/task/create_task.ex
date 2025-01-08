defmodule Todos.UseCase.Task.CreateTask do
  @moduledoc """
  Create a new task.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Story.GetStory

  @behaviour Todos.UseCase
  def execute(args) do
    # Makes sure the story exists, and is owned by the requestor.
    case GetStory.execute(args) do
      {:ok, _} -> args |> add_status() |> create_task()
      error -> error
    end
  end

  # Add default status to provided args.
  defp add_status(args),
    do: %{name: Map.get(args, :name), status: :todo, story_id: args.story_id}

  # Create a task
  defp create_task(args) do
    case task_keeper().create_task(args) do
      {:ok, task} -> {:ok, %{task: Dto.from_schema(task)}}
      error -> error
    end
  end
end
