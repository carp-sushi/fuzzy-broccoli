defmodule StoryUtil do
  @moduledoc """
  Test helper functions for creating story mocks.
  """
  import Hammox
  alias Todos.Data.Schema.Story
  alias Todos.Dto

  @doc """
  Create a fake story, and define mock keeper behaviour for getting the story by ID.
  """
  def mock_get_story do
    # Generate a fake story
    story = FakeData.generate_story()

    # Setup mock keeper function to get the fake or return an error
    StoryKeeperMock
    |> expect(:get_story, fn id ->
      if id == story.id, do: {:ok, story}, else: {:error, "story not found: #{id}"}
    end)

    # Return the fake story for reference in tests
    story
  end

  @doc """
  Create a fake story database, and define mock keeper behaviour for listing stories by
  blockchain address.
  """
  def mock_list_stories do
    # Generate a lookup address for tests
    blockchain_address = FakeData.generate_blockchain_address()

    # Generate a fake database of stories
    misses = Stream.repeatedly(fn -> FakeData.generate_story() end) |> Enum.take(7)
    hits = Stream.repeatedly(fn -> FakeData.generate_story(blockchain_address) end) |> Enum.take(3)
    db = Enum.shuffle(hits ++ misses)

    # Setup a mock keeper function to filter the database by a given blockchain address
    StoryKeeperMock
    |> expect(:list_stories, fn addr ->
      Enum.filter(db, fn s -> s.blockchain_address == addr end) |> Enum.map(&Dto.from_schema/1)
    end)

    # Return the lookup address and database for reference in tests
    {blockchain_address, db}
  end

  @doc """
  Set up a mock for creating validated stories.
  """
  def mock_create_story do
    # Just delegate to the ecto schema validator for mock create story.
    StoryKeeperMock
    |> expect(:create_story, fn args ->
      %Story{id: Nanoid.generate()} |> Story.changeset(args) |> TestUtil.evaluate_changeset()
    end)
  end

  @doc """
  Set up a mock for deleting existing stories.
  """
  def mock_delete_story do
    # Generate a fake story that can be deleted.
    story = mock_get_story()

    # Create a mock keeper function that will check for the fake story on deletion.
    StoryKeeperMock
    |> expect(:delete_story, fn id ->
      if id == story.id, do: {1, nil}, else: {0, nil}
    end)

    # Return the fake story for reference in tests
    story
  end

  @doc """
  Set up a mock for updating existing stories.
  """
  def mock_update_story do
    # Generate a fake story that can be updated.
    story = mock_get_story()

    # Check for fake story and delegate to the ecto schema validator for mock keeper update.
    StoryKeeperMock
    |> expect(:update_story, fn struct, params ->
      if struct.id == story.id do
        struct |> Story.changeset(params) |> TestUtil.evaluate_changeset()
      else
        {:error, "story not found: #{struct.id}"}
      end
    end)

    # Return the fake story for reference in tests
    story
  end
end
