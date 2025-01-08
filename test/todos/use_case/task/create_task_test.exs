defmodule Todos.UseCase.Task.CreateTaskTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Task.CreateTask

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story, task and args in a test context.
  setup do
    story = StoryUtil.mock_get_story()
    TaskUtil.mock_create_task()
    name = Nanoid.generate()
    args = %{name: name, story_id: story.id, blockchain_address: story.blockchain_address}
    %{args: args, expect: %{name: name}}
  end

  # CreateTask use case tests
  describe "CreateTask" do
    test "should create a new task given valid args", ctx do
      assert {:ok, %{task: task}} = CreateTask.execute(ctx.args)
      assert task.name == ctx.expect.name
      assert task.status == :todo
    end

    test "should return an error when a task name is not provided", ctx do
      args = %{story_id: ctx.args.story_id, blockchain_address: ctx.args.blockchain_address}
      assert {:error, error} = CreateTask.execute(args)
      assert String.starts_with?(error.message, "validation failure")
    end

    test "should return an error when a task name is too long", ctx do
      args = Map.merge(ctx.args, %{name: Nanoid.generate(101)})
      assert {:error, error} = CreateTask.execute(args)
      assert String.starts_with?(error.message, "validation failure")
    end

    test "should return an error message given empty args" do
      assert {:error, message} = CreateTask.execute(%{})
      assert message == "missing required args: [:story_id, :blockchain_address]"
    end
  end
end
