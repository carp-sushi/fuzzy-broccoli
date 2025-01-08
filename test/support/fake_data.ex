defmodule FakeData do
  @moduledoc """
  Test helper functions for generating fake data.
  """
  alias Todos.Data.Schema.{Story, Task}

  @doc "Generate a fake blockchain address."
  def generate_blockchain_address,
    do: "tp#{Nanoid.generate(39)}" |> String.downcase()

  @doc "Generate fake story args."
  def generate_story_args,
    do: %{
      story_id: Nanoid.generate(),
      blockchain_address: generate_blockchain_address()
    }

  @doc "Generate a fake story for a blockchain address (nillable)."
  def generate_story(blockchain_address \\ nil) do
    %Story{
      id: Nanoid.generate(),
      blockchain_address: blockchain_address || generate_blockchain_address(),
      name: "name:#{Nanoid.generate(10)}",
      description: "description:#{Nanoid.generate(20)}"
    }
  end

  @doc "Generate a fake task for a story."
  def generate_task(story_id \\ nil) do
    %Task{
      id: Nanoid.generate(),
      story_id: story_id || Nanoid.generate(),
      name: "name:#{Nanoid.generate(10)}",
      status: :todo
    }
  end
end
