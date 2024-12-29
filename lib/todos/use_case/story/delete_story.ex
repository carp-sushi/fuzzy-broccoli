defmodule Todos.UseCase.Story.DeleteStory do
  @moduledoc """
  Delete a story.
  """
  use Todos.Data.Keeper
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    Args.validate(args, [:story_id, :blockchain_address], fn ->
      case stories().get(args.story_id) do
        {:error, error} -> {:not_found, error}
        {:ok, story} -> delete_story(story, args.blockchain_address)
      end
    end)
  end

  # Verify the story is owned by the requestor before deletion.
  defp delete_story(story, blockchain_address) do
    case story.blockchain_address == blockchain_address do
      true -> stories().delete(story) |> result()
      false -> {:not_found, "story not found: #{story.id}"}
    end
  end

  # wrap success or failure data transfer objects.
  defp result({:ok, _story}), do: :no_content
  defp result({:error, error}), do: {:internal_error, error}
end
