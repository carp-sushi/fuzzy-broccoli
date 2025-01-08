defmodule Todos.Data.Schema.StoryTest do
  use ExUnit.Case, async: true
  alias Todos.Data.Schema.Story

  setup do
    %{
      params: %{
        name: "Test Story",
        description: "This is a test story",
        blockchain_address: FakeData.generate_blockchain_address()
      }
    }
  end

  # Test story changeset validations
  describe "Story.changeset" do
    test "it succeeds on valid params", ctx do
      result = Story.changeset(%Story{}, ctx.params)
      assert result.valid?
    end

    test "it fails on missing name" do
      params = %{blockchain_address: FakeData.generate_blockchain_address()}
      result = Story.changeset(%Story{}, params)
      refute result.valid?
      assert result.errors[:name]
    end

    test "it fails on missing blockchain address" do
      result = Story.changeset(%Story{}, %{name: Nanoid.generate()})
      refute result.valid?
      assert result.errors[:blockchain_address]
    end

    test "it fails on invalid blockchain address prefix" do
      params = %{name: Nanoid.generate(), blockchain_address: Nanoid.generate(41)}
      result = Story.changeset(%Story{}, params)
      refute result.valid?
      assert result.errors[:blockchain_address]
    end

    test "it fails on empty params" do
      result = Story.changeset(%Story{}, %{})
      refute result.valid?
      assert result.errors[:name]
      assert result.errors[:blockchain_address]
    end
  end
end
