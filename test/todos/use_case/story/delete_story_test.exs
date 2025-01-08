defmodule Todos.UseCase.Story.DeleteStoryTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Story.DeleteStory

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story and args in a test context.
  setup do
    story = StoryUtil.mock_delete_story()
    args = %{story_id: story.id, blockchain_address: story.blockchain_address}
    %{args: args}
  end

  # DeleteStory use case tests
  describe "DeleteStory" do
    test "should delete an existing story given valid args", ctx do
      assert :ok = DeleteStory.execute(ctx.args)
    end

    test "should return an error given empty args" do
      assert {:error, message} = DeleteStory.execute(%{})
      assert message == "missing required args: [:story_id, :blockchain_address]"
    end

    test "should return an error when deleting a story that does not exist" do
      assert {:error, message, status} = DeleteStory.execute(FakeData.generate_story_args())
      assert String.starts_with?(message, "story not found")
      assert status == :not_found
    end
  end
end
