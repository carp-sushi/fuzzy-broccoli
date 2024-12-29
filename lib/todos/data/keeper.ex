defmodule Todos.Data.Keeper do
  @moduledoc """
  Macro for loading keepers in use cases (allows for injecting mocks for testing).
  """
  defmacro __using__(_opts) do
    quote do
      alias Todos.Data.Keeper.StoryKeeper
      alias Todos.Data.Repo.StoryRepo

      @spec story_keeper :: StoryKeeper
      defp story_keeper do
        Application.get_env(:todos, :story_keeper, StoryRepo)
      end
    end
  end
end
