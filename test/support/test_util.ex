defmodule TestUtil do
  @moduledoc """
  Test helper functions.
  """
  alias Ecto.Changeset
  alias Todos.Error

  @doc """
  Evaluate a changeset, returning the data structure (success) -or- errors.
  """
  def evaluate_changeset(changeset) do
    if changeset.valid? do
      {:ok, Changeset.apply_changes(changeset)}
    else
      {:error, Error.extract(changeset)}
    end
  end
end
