defmodule Todos.UseCase.Story.GetStory do
  @moduledoc """
  Get a story.
  """
  use Todos.Data.Keeper

  alias Todos.Dto
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    case Args.take(args, [:story_id, :blockchain_address]) do
      {:ok, story_id, blockchain_address} -> get_story(story_id, blockchain_address)
      error -> error
    end
  end

  # Get story from keeper
  defp get_story(story_id, blockchain_address) do
    case story_keeper().get_story(story_id) do
      {:ok, story} -> verify_ownership(story, blockchain_address)
      {:error, message} -> {:error, "#{message}: #{story_id}", :not_found}
    end
  end

  # Ensure the story returned from the keeper is owned by the requestor.
  defp verify_ownership(story, blockchain_address) do
    if story.blockchain_address == blockchain_address do
      {:ok, %{story: Dto.from_schema(story)}}
    else
      {:error, "access denied", :forbidden}
    end
  end
end
