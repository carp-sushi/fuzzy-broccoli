defmodule Todos.Data.Keeper.StoryKeeper do
  @moduledoc """
  Data keeper for managing stories.
  """
  alias Todos.Data.Schema.Story

  @doc "Get a story"
  @callback get_story(String.t()) :: {:ok, Story.t()} | {:error, any}

  @doc "Create a new story"
  @callback create_story(map) :: {:ok, Story.t()} | {:error, any}

  @doc "List stories for a blockchain address."
  @callback list_stories(String.t()) :: list(Story.t())

  @doc "Delete a story."
  @callback delete_story(Story.t()) :: {:ok, Story.t()} | {:error, any}

  @doc "Update a story."
  @callback update_story(Story.t(), map) :: {:ok, Story.t()} | {:error, any}
end
