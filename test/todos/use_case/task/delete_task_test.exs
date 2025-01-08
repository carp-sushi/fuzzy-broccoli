defmodule Todos.UseCase.Task.DeleteTaskTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Task.DeleteTask

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story and args in a test context.
  setup do
    story = StoryUtil.mock_get_story()
    task = TaskUtil.mock_delete_task(story.id)
    %{args: %{task_id: task.id, story_id: story.id, blockchain_address: story.blockchain_address}}
  end

  # DeleteTask use case tests
  describe "DeleteTask" do
    test "should delete an existing task given valid args", ctx do
      assert :ok = DeleteTask.execute(ctx.args)
    end

    test "should return an error when deleting a task that does not exist", ctx do
      args = Map.merge(ctx.args, %{task_id: Nanoid.generate()})
      assert {:error, message, status} = DeleteTask.execute(args)
      assert String.starts_with?(message, "task not found")
      assert status == :not_found
    end

    test "should return an error given empty args" do
      assert {:error, message} = DeleteTask.execute(%{})
      assert String.starts_with?(message, "missing required args")
    end
  end
end
