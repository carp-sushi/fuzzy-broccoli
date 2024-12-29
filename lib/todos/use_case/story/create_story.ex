defmodule Todos.UseCase.Story.CreateStory do
  @moduledoc """
  Create a new story.
  """
  use Todos.Data.Keeper

  @behaviour Todos.UseCase
  def execute(args) do
    Todos.UseCase.Args.validate(args, [:name, :blockchain_address], fn ->
      case stories().create(args) do
        {:ok, story} -> {:created, %{story: Todos.Dto.from_schema(story)}}
        {:error, error} -> {:invalid_args, error}
      end
    end)
  end
end
