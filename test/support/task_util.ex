defmodule TaskUtil do
  @moduledoc """
  Test helper functions for creating task mocks.
  """
  import Hammox
  alias Todos.Data.Schema.Task

  @doc """
  Create a fake task, and define mock keeper behaviour for getting the task by ID.
  """
  def mock_get_task(story_id) do
    # Generate a fake task for a given story
    task = FakeData.generate_task(story_id)

    # Setup mock keeper function to get the fake or return an error
    TaskKeeperMock
    |> expect(:get_task, fn id ->
      if id == task.id, do: {:ok, task}, else: {:error, "task not found: #{id}"}
    end)

    # Return the fake task for reference in tests
    task
  end

  @doc """
  Create a fake task database, and define mock keeper behaviour for listing tasks by story.
  """
  def mock_list_tasks(story_id) do
    # Generate a series of fake tasks
    misses = Stream.repeatedly(fn -> FakeData.generate_task() end) |> Enum.take(7)
    hits = Stream.repeatedly(fn -> FakeData.generate_task(story_id) end) |> Enum.take(3)

    # Create a database of tasks
    db = Enum.shuffle(hits ++ misses)

    # Setup a mock keeper function to filter the database by a given story ID.
    TaskKeeperMock
    |> expect(:list_tasks, fn id ->
      Enum.filter(db, fn t -> t.story_id == id end)
    end)

    # Return the database for reference in tests
    db
  end

  @doc """
  Set up a mock for creating validated tasks.
  """
  def mock_create_task do
    # Just delegate to the ecto schema validator for mock create task.
    TaskKeeperMock
    |> expect(:create_task, fn args ->
      %Task{id: Nanoid.generate()} |> Task.changeset(args) |> TestUtil.evaluate_changeset()
    end)
  end

  @doc """
  Set up a mock for deleting existing tasks.
  """
  def mock_delete_task(story_id) do
    # Generate a fake task that can be deleted.
    task = mock_get_task(story_id)

    # Create a mock keeper function that will check for the fake task on deletion.
    TaskKeeperMock
    |> expect(:delete_task, fn id ->
      if id == task.id, do: {1, nil}, else: {0, nil}
    end)

    # Return the fake task for reference in tests
    task
  end

  @doc """
  Set up a mock for updating existing tasks.
  """
  def mock_update_task(story_id) do
    # Generate a fake task that can be updated.
    task = mock_get_task(story_id)

    # Check for fake task and delegate to the ecto schema validator for mock keeper update.
    TaskKeeperMock
    |> expect(:update_task, fn struct, params ->
      if struct.id == task.id do
        struct |> Task.changeset(params) |> TestUtil.evaluate_changeset()
      else
        {:error, "task not found: #{struct.id}"}
      end
    end)

    # Return the fake task for reference in tests
    task
  end
end
