defmodule Todos.UseCase.Task.GetTaskTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Task.GetTask

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story, task and args in a test context.
  setup do
    story = StoryUtil.mock_get_story()
    task = TaskUtil.mock_get_task(story.id)
    args = %{task_id: task.id, story_id: story.id, blockchain_address: story.blockchain_address}
    %{args: args, expect: %{name: task.name}}
  end

  # GetTask use case tests
  describe "GetTask" do
    test "should return an existing task", ctx do
      assert {:ok, %{task: task}} = GetTask.execute(ctx.args)
      assert task.name == ctx.expect.name
    end

    test "should return an error on empty args" do
      assert {:error, message} = GetTask.execute(%{})
      assert String.starts_with?(message, "missing required args")
    end

    test "should return an error when a task is not found", ctx do
      args = Map.merge(ctx.args, %{task_id: Nanoid.generate()})
      assert {:error, message, status} = GetTask.execute(args)
      assert String.starts_with?(message, "task not found")
      assert status == :not_found
    end
  end
end
