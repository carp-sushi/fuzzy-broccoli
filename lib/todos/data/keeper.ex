defmodule Todos.Data.Keeper do
  @moduledoc """
  Macro for loading keepers in use cases (allows for injecting mocks for testing).
  """
  defmacro __using__(_opts) do
    quote do
      alias Todos.Data.Keeper.{StoryKeeper, TaskKeeper}
      alias Todos.Data.Repo.{StoryRepo, TaskRepo}

      @spec story_keeper :: StoryKeeper
      defp story_keeper do
        Application.get_env(:todos, :story_keeper, StoryRepo)
      end

      @spec task_keeper :: TaskKeeper
      defp task_keeper do
        Application.get_env(:todos, :task_keeper, TaskRepo)
      end
    end
  end
end
