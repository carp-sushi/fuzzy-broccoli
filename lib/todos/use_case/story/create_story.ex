defmodule Todos.UseCase.Story.CreateStory do
  @moduledoc """
  Create a new story.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    case Args.take(args, [:name, :blockchain_address]) do
      {:ok, name, blockchain_address} -> create_story(name, blockchain_address)
      error -> error
    end
  end

  # create helper
  defp create_story(name, blockchain_address) do
    %{name: name, blockchain_address: blockchain_address}
    |> story_keeper().create_story()
    |> case do
      {:ok, story} -> {:ok, %{story: Dto.from_schema(story)}}
      error -> error
    end
  end
end
