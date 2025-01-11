defmodule Todos.UseCase.Story.ListStoriesTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Story.ListStories

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story database and args in a test context.
  setup do
    {blockchain_address, db} = StoryUtil.mock_list_stories()
    args = %{blockchain_address: blockchain_address}
    %{args: args, expect: blockchain_address, db: db}
  end

  # ListStories use case tests
  describe "ListStories" do
    test "should return all stories for a blockchain address", ctx do
      assert {:ok, %{stories: stories}} = ListStories.execute(ctx.args)
      assert Enum.all?(stories, fn s -> s.blockchain_address == ctx.expect end)
      assert length(stories) == Enum.count(ctx.db, fn s -> s.blockchain_address == ctx.expect end)
    end

    test "should return an error given empty args" do
      assert {:error, message} = ListStories.execute(%{})
      assert message == "missing required arg: blockchain_address"
    end
  end
end
