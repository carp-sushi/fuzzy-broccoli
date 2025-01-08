defmodule Todos.UseCase.Task.ListTasksTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Task.ListTasks

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story, task database and args in a test context.
  setup do
    story = StoryUtil.mock_get_story()
    db = TaskUtil.mock_list_tasks(story.id)
    args = %{story_id: story.id, blockchain_address: story.blockchain_address}
    %{args: args, db: db, expect: %{story_id: story.id}}
  end

  # ListTasks use case tests
  describe "ListTasks" do
    test "should return all tasks for a story", ctx do
      assert {:ok, %{tasks: tasks}} = ListTasks.execute(ctx.args)
      assert Enum.all?(tasks, fn t -> t.story_id == ctx.expect.story_id end)
      assert length(tasks) == Enum.count(ctx.db, fn t -> t.story_id == ctx.expect.story_id end)
    end

    test "should return an error on invalid args" do
      assert {:error, message} = ListTasks.execute(%{})
      assert message == "missing required args: [:story_id, :blockchain_address]"
    end
  end
end
