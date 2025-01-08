defmodule Todos.UseCase.Story.UpdateStoryTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Story.UpdateStory

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story and args in a test context.
  setup do
    story = StoryUtil.mock_update_story()
    updated_name = Nanoid.generate(10)
    args = %{story_id: story.id, blockchain_address: story.blockchain_address, name: updated_name}
    %{args: args, expect: %{name: updated_name}}
  end

  # UpdateStory use case tests
  describe "UpdateStory" do
    test "should update an existing story given valid args", ctx do
      assert {:ok, %{story: story}} = UpdateStory.execute(ctx.args)
      assert story.name == ctx.expect.name
    end

    test "should return an error given empty args" do
      assert {:error, message} = UpdateStory.execute(%{})
      assert message == "missing required args: [:story_id, :blockchain_address]"
    end

    test "should return an error given invalid args", ctx do
      args = Map.merge(ctx.args, %{name: Nanoid.generate(101)})
      assert {:error, error} = UpdateStory.execute(args)
      assert error.message == "validation failure"
    end
  end
end
