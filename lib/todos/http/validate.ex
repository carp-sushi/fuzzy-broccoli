defmodule Todos.Http.Validate do
  @moduledoc """
  Http header and request validators.
  """
  alias Ecto.Changeset
  import Ecto.Changeset

  alias Todos.Error

  @doc """
  Parse arguments for creating new stories from a request body.
  """
  def create_story_request(conn) do
    {%{}, %{name: :string, description: :string}}
    |> Changeset.cast(conn.body_params, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, max: 100)
    |> validate_length(:description, max: 1000)
    |> unpack_changes()
  end

  @doc """
  Parse arguments for updating existing stories from a request body.
  """
  def update_story_request(conn, data) do
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
  def create_task_request(conn, data) do
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
  def update_task_request(conn, data) do
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
