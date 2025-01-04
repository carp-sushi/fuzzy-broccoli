defmodule Todos.Data.Keeper.StoryKeeper do
  @moduledoc """
  Data keeper for managing stories.
  """
  alias Todos.Data.Schema.Story

  @doc "Create a new story"
  @callback create_story(map) :: {:ok, Story.t()} | {:error, any}

  @doc "Read a story"
  @callback get_story(String.t()) :: {:ok, Story.t()} | {:error, any}

  @doc "Read a list of stories for a blockchain address."
  @callback list_stories(String.t()) :: list(map)

  @doc "Update a story."
  @callback update_story(Story.t(), map) :: {:ok, Story.t()} | {:error, any}

  @doc "Delete a story."
  @callback delete_story(String.t()) :: {non_neg_integer(), nil | [term()]}
end
