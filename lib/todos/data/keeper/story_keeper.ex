defmodule Todos.Data.Keeper.StoryKeeper do
  @moduledoc """
  Data keeper for managing stories.
  """
  alias Todos.Data.Schema.Story

  @doc "Get a story"
  @callback get(String.t()) :: {:ok, Story.t()} | {:error, any}

  @doc "Create a new story"
  @callback create(map) :: {:ok, Story.t()} | {:error, any}

  @doc "List stories for a blockchain address."
  @callback list(String.t()) :: list(Story.t())

  @doc "Delete a story."
  @callback delete(Story.t()) :: {:ok, Story.t()} | {:error, any}
end
