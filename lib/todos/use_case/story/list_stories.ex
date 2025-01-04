defmodule Todos.UseCase.Story.ListStories do
  @moduledoc """
  Get stories for a blockchain address.
  """
  use Todos.Data.Keeper
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    Args.validate(args, [:blockchain_address], fn ->
      stories = story_keeper().list_stories(args.blockchain_address)
      {:ok, %{stories: stories}}
    end)
  end
end
