defmodule Todos.Http.Validate do
  @moduledoc """
  Http request validations
  """
  alias Ecto.Changeset
  import Ecto.Changeset

  alias Todos.Error

  @doc """
  Validate a blockhain address pulled from a request header.
  """
  def blockchain_address(blockchain_address) do
    data = %{}
    types = %{blockchain_address: :string}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(%{blockchain_address: blockchain_address}, keys)
      |> Todos.Util.Validate.blockchain_address()

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end

  @doc """
  Parse arguments for creating new stories from a request body.
  """
  def create_story_args(conn) do
    data = %{}
    types = %{name: :string, description: :string}

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, [:name, :description])
      |> validate_required([:name])
      |> validate_length(:name, max: 100)
      |> validate_length(:description, max: 1000)

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end

  @doc """
  Parse arguments for updating existing stories from a request body.
  """
  def update_story_args(conn, story_id) do
    data = %{story_id: story_id}
    types = %{name: :string, description: :string}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_length(:name, max: 100)
      |> validate_length(:description, max: 1000)

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end

  @doc """
  Parse arguments for creating new tasks from a request body.
  """
  def create_task_args(conn, story_id) do
    data = %{story_id: story_id}
    types = %{name: :string}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_required(keys)
      |> validate_length(:name, max: 100)

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end

  @doc """
  Parse arguments for updating existing tasks from a request body.
  """
  def update_task_args(conn, story_id, task_id) do
    data = %{story_id: story_id, task_id: task_id}
    types = %{name: :string, status: :string}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_length(:name, max: 100)
      |> validate_inclusion(:status, ["todo", "done"])

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end
end
