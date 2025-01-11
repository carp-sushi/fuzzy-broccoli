defmodule Todos.UseCase.Story.ListStories do
  @moduledoc """
  Get stories for a blockchain address.
  """
  use Todos.Data.Keeper
  alias Todos.UseCase.Args

  @behaviour Todos.UseCase
  def execute(args) do
    case Args.get(args, :blockchain_address) do
      {:ok, blockchain_address} -> list_stories(blockchain_address)
      error -> error
    end
  end

  # list stories logic
  defp list_stories(blockchain_address) do
    stories = story_keeper().list_stories(blockchain_address)
    {:ok, %{stories: stories}}
  end
end
