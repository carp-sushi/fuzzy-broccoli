defmodule Todos.UseCase.Story.DeleteStory do
  @moduledoc """
  Delete a story.
  """
  use Todos.Data.Keeper
  alias Todos.UseCase.Story.GetStory

  require Logger

  @behaviour Todos.UseCase
  def execute(args) do
    case GetStory.execute(args) do
      {:ok, %{story: story}} -> delete_story(story.id)
      error -> error
    end
  end

  # Verify the story is owned by the requestor before deletion.
  defp delete_story(story_id) do
    {n, _} = story_keeper().delete_story(story_id)
    Logger.debug("deleted #{n} stories")
    :ok
  end
end
