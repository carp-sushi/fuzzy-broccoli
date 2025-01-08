defmodule Todos.UseCase.Story.GetStory do
  @moduledoc """
  Get a story.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    Args.validate(args, [:story_id, :blockchain_address], fn ->
      case story_keeper().get_story(args.story_id) do
        {:error, error} -> {:error, error, :not_found}
        {:ok, story} -> verify_ownership(story, args.blockchain_address)
      end
    end)
  end

  # Ensure the story return from the keeper is owned by the requestor.
  defp verify_ownership(story, blockchain_address) do
    case story.blockchain_address == blockchain_address do
      true -> {:ok, %{story: Dto.from_schema(story)}}
      false -> {:error, "story not found: #{story.id}", :not_found}
    end
  end
end
