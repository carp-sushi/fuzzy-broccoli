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

    {data, types}
    |> Changeset.cast(%{blockchain_address: blockchain_address}, keys)
    |> Todos.Util.Validate.blockchain_address()
    |> unpack_changes()
  end

  @doc """
  Parse arguments for creating new stories from a request body.
  """
  def create_story_args(conn, data \\ %{}) do
    {data, %{name: :string, description: :string}}
    |> Changeset.cast(conn.body_params, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, max: 100)
    |> validate_length(:description, max: 1000)
    |> unpack_changes()
  end

  @doc """
  Parse arguments for updating existing stories from a request body.
  """
  def update_story_args(conn, data \\ %{}) do
    types = %{name: :string, description: :string}

    {data, types}
    |> Changeset.cast(conn.body_params, Map.keys(types))
    |> validate_length(:name, max: 100)
    |> validate_length(:description, max: 1000)
    |> unpack_changes()
  end

  @doc """
  Parse arguments for creating new tasks from a request body.
  """
  def create_task_args(conn, data \\ %{}) do
    types = %{name: :string}
    keys = Map.keys(types)

    {data, types}
    |> Changeset.cast(conn.body_params, keys)
    |> validate_required(keys)
    |> validate_length(:name, max: 100)
    |> unpack_changes()
  end

  @doc """
  Parse arguments for updating existing tasks from a request body.
  """
  def update_task_args(conn, data \\ %{}) do
    types = %{name: :string, status: :string}

    {data, types}
    |> Changeset.cast(conn.body_params, Map.keys(types))
    |> validate_length(:name, max: 100)
    |> validate_inclusion(:status, ["todo", "done"])
    |> unpack_changes()
  end

  # Unpack a changeset into success or error tuple.
  defp unpack_changes(changeset) do
    if changeset.valid? do
      {:ok, Changeset.apply_changes(changeset)}
    else
      {:error, Error.extract(changeset)}
    end
  end
end
