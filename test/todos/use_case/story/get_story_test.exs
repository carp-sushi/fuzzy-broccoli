defmodule Todos.UseCase.Story.GetStoryTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Story.GetStory

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story and args in a test context.
  setup do
    story = StoryUtil.mock_get_story()
    args = %{story_id: story.id, blockchain_address: story.blockchain_address}
    %{args: args, expect: %{name: story.name}}
  end

  # GetStory use case tests
  describe "GetStory" do
    test "should return an existing story", ctx do
      assert {:ok, %{story: story}} = GetStory.execute(ctx.args)
      assert story.name == ctx.expect.name
    end

    test "should return an error on invalid args" do
      assert {:error, message} = GetStory.execute(%{})
      assert String.starts_with?(message, "missing required args")
    end

    test "should return an error when a story is not found" do
      assert {:error, message, status} = GetStory.execute(FakeData.generate_story_args())
      assert String.starts_with?(message, "story not found")
      assert status == :not_found
    end

    test "should return an error on ownership mismatch", ctx do
      args = Map.merge(ctx.args, %{blockchain_address: FakeData.generate_blockchain_address()})
      assert {:error, message, status} = GetStory.execute(args)
      assert {message, status} == {"access denied", :forbidden}
    end
  end
end
