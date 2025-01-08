defmodule Todos.UseCase.Story.CreateStoryTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Todos.UseCase.Story.CreateStory

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock story and args in a test context.
  setup do
    StoryUtil.mock_create_story()
    blockchain_address = FakeData.generate_blockchain_address()
    args = %{name: Nanoid.generate(10), blockchain_address: blockchain_address}
    %{args: args, expect: %{blockchain_address: blockchain_address}}
  end

  # CreateStory use case tests
  describe "CreateStory" do
    test "should create a new story given valid args", ctx do
      assert {:ok, %{story: story}} = CreateStory.execute(ctx.args)
      assert story.blockchain_address == ctx.expect.blockchain_address
    end

    test "should return an error given empty args" do
      assert {:error, message} = CreateStory.execute(%{})
      assert message == "missing required args: [:name, :blockchain_address]"
    end

    test "should return an error given invalid args" do
      args = %{name: Nanoid.generate(101), blockchain_address: Nanoid.generate(33)}
      assert {:error, error} = CreateStory.execute(args)
      assert error.message == "validation failure"
    end
  end
end
