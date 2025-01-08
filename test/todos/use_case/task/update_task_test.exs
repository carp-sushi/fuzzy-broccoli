defmodule Todos.UseCase.Task.UpdateTaskTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Task.UpdateTask

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story, task and args in a test context.
  setup do
    story = StoryUtil.mock_get_story()
    task = TaskUtil.mock_update_task(story.id)
    status = :done
    args = %{status: status, task_id: task.id, story_id: story.id, blockchain_address: story.blockchain_address}
    %{args: args, expect: %{status: status}}
  end

  # UpdateTask use case tests
  describe "UpdateTask" do
    test "should update an existing task given valid args", ctx do
      assert {:ok, %{task: task}} = UpdateTask.execute(ctx.args)
      assert task.status == ctx.expect.status
    end

    test "should return an error when updating a task that does not exist", ctx do
      args = Map.merge(ctx.args, %{task_id: Nanoid.generate()})
      assert {:error, message, status} = UpdateTask.execute(args)
      assert String.starts_with?(message, "task not found")
      assert status == :not_found
    end

    test "should return an error when updating a task to an invalid status", ctx do
      args = Map.merge(ctx.args, %{status: "invalid"})
      assert {:error, error} = UpdateTask.execute(args)
      assert error.message == "validation failure"
    end

    test "should return an error given empty args" do
      assert {:error, message} = UpdateTask.execute(%{})
      assert String.starts_with?(message, "missing required args")
    end
  end
end
