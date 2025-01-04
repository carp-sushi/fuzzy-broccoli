defmodule Todos.Data.Schema.TaskTest do
  use ExUnit.Case, async: true
  alias Todos.Data.Schema.Task

  require Logger

  setup do
    %{
      params: %{
        name: "Test Task",
        status: "todo",
        story_id: Nanoid.generate()
      }
    }
  end

  # Test task changeset validations
  describe "Task.changeset" do
    test "it succeeds on valid params", ctx do
      result = Task.changeset(%Task{}, ctx.params)
      assert result.valid?
    end

    test "it fails when all required params are missing" do
      result = Task.changeset(%Task{}, %{})
      refute result.valid?
      assert result.errors[:name]
      assert result.errors[:status]
      assert result.errors[:story_id]
    end

    test "it fails when an invalid status is provided", ctx do
      params = Map.merge(ctx.params, %{status: "boom"})
      result = Task.changeset(%Task{}, params)
      refute result.valid?
      assert result.errors[:status]
    end

    test "it fails when an invalid name is provided (too long)", ctx do
      params = Map.merge(ctx.params, %{name: Nanoid.generate(101)})
      result = Task.changeset(%Task{}, params)
      refute result.valid?
      assert result.errors[:name]
    end
  end
end
