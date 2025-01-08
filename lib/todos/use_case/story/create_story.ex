defmodule Todos.UseCase.Story.CreateStory do
  @moduledoc """
  Create a new story.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    Args.validate(args, [:name, :blockchain_address], fn ->
      case story_keeper().create_story(args) do
        {:ok, story} -> {:ok, %{story: Dto.from_schema(story)}}
        error -> error
      end
    end)
  end
end
