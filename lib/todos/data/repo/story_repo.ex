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

  @doc "Create a new story."
  def create_story(params) do
    %Story{}
    |> Story.changeset(params)
    |> Repo.insert()
    |> case do
      {:error, cs} -> {:error, Error.extract(cs)}
      result -> result
    end
  end

  @doc "Get a story"
  def get_story(id) do
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

  @doc "Get stories for a blockchain address, loaded directly as DTOs."
  def list_stories(blockchain_address) do
    Story
    |> select([s], map(s, [:id, :name, :description, :blockchain_address]))
    |> where([s], s.blockchain_address == ^blockchain_address and is_nil(s.deleted_at))
    |> order_by([s], desc: s.inserted_at)
    |> limit(@max_records)
    |> Repo.all()
  end

  @doc "Update a story."
  def update_story(struct, params) do
    struct
    |> Story.changeset(params)
    |> Repo.update()
    |> case do
      {:error, cs} -> {:error, Error.extract(cs)}
      result -> result
    end
  end

  @doc "Delete a story."
  def delete_story(id) do
    update_all(
      from(s in Story,
        where: s.id == ^id and is_nil(s.deleted_at),
        update: [set: [deleted_at: ^Clock.now()]]
      )
    )
  end

  # Helper for readability
  defp update_all(queryable),
    do: queryable |> Repo.update_all([])
end
