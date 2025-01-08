defmodule Todos.UseCase.Story.UpdateStory do
  @moduledoc """
  Update a story.
  """
  alias Todos.Dto
  use Todos.Data.Keeper

  alias Todos.Data.Schema.Story
  alias Todos.UseCase.Story.GetStory

  @behaviour Todos.UseCase
  def execute(args) do
    case GetStory.execute(args) do
      {:ok, %{story: story}} -> args |> unpack_updates(story) |> update_story(story)
      error -> error
    end
  end

  # Unpack any updates, falling back to existing values.
  defp unpack_updates(args, story),
    do: %{
      name: Map.get(args, :name) || story.name,
      description: Map.get(args, :description) || story.description
    }

  # Performs the story update.
  defp update_story(updates, story) do
    story
    |> to_schema()
    |> story_keeper().update_story(updates)
    |> case do
      {:ok, updated} -> {:ok, %{story: Dto.from_schema(updated)}}
      error -> error
    end
  end

  # Create a schema struct with identifiers set.
  defp to_schema(data),
    do: %Story{
      id: data.id,
      blockchain_address: data.blockchain_address
    }
end
