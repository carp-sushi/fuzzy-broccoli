defmodule Todos.Data.Schema.StoryTest do
  use ExUnit.Case, async: true
  alias Todos.Data.Schema.Story

  # require Logger

  setup do
    %{
      name: "Test",
      description: "This is a test story",
      blockchain_address: "tp#{Nanoid.generate(39)}"
    }
  end

  # Test story changeset validations
  describe "Story.changeset" do
    test "it succeeds on valid params", params do
      result = Story.changeset(%Story{}, params)
      assert result.valid?
    end

    test "it fails on missing name" do
      params = %{blockchain_address: "tp#{Nanoid.generate(39)}"}
      result = Story.changeset(%Story{}, params)
      refute result.valid?
      assert result.errors[:name], "can't be blank"
    end

    test "it fails on missing blockchain address" do
      result = Story.changeset(%Story{}, %{name: Nanoid.generate()})
      refute result.valid?
      assert result.errors[:blockchain_address], "can't be blank"
    end

    test "it fails on invalid blockchain address prefix" do
      params = %{name: Nanoid.generate(), blockchain_address: Nanoid.generate(41)}
      result = Story.changeset(%Story{}, params)
      refute result.valid?
      assert result.errors[:blockchain_address], "must have prefix: tp"
    end

    test "it fails on empty params" do
      result = Story.changeset(%Story{}, %{})
      refute result.valid?
      # Logger.error("errors = #{inspect(result.errors)}")
      assert result.errors[:name], "can't be blank"
      assert result.errors[:blockchain_address], "can't be blank"
    end
  end
end
