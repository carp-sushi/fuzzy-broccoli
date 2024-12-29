defmodule Todos.Data.Repo.StoryRepo do
  @moduledoc """
  Data repo (concrete keeper) for managing stories.
  """
  @behaviour Todos.Data.Keeper.StoryKeeper

  alias Todos.Data.Schema.Story
  alias Todos.{Error, Repo}
  alias Todos.Util.Clock

  import Ecto.Query

  # Sets a maximum on query result size.
  @max_records Application.compile_env(:todos, :max_records)

  @doc "Get a story"
  def get(id) do
    Repo.one(
      from(s in Story,
        where: s.id == ^id and is_nil(s.deleted_at),
        select: s
      )
    )
    |> case do
      nil -> {:error, "story not found: #{id}"}
      story -> {:ok, story}
    end
  end

  @doc "Create a new story."
  def create(params) do
    %Story{}
    |> Story.changeset(params)
    |> Repo.insert()
    |> case do
      {:error, cs} -> {:error, Error.extract(cs)}
      result -> result
    end
  end

  @doc "Get stories for a blockchain address."
  def list(blockchain_address) do
    Repo.all(
      from(s in Story,
        where: s.blockchain_address == ^blockchain_address and is_nil(s.deleted_at),
        order_by: [desc: s.inserted_at],
        limit: @max_records,
        select: s
      )
    )
  end

  @doc "Delete a story."
  def delete(struct) do
    struct
    |> Story.changeset(%{deleted_at: Clock.now()})
    |> Repo.update()
    |> case do
      {:error, cs} -> {:error, Error.extract(cs)}
      result -> result
    end
  end
end
