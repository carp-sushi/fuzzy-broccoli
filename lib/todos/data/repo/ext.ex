defmodule Todos.Data.Repo.Ext do
  @moduledoc """
  Repo extension functions.
  """
  alias Todos.Repo

  @doc "A batch update helper"
  def update_all(queryable, opts \\ []) do
    Repo.update_all(queryable, opts)
  end

  @doc "Wraps `Repo.one` result in a status tuple."
  def one(queryable) do
    case Repo.one(queryable) do
      nil -> {:error, "not found"}
      row -> {:ok, row}
    end
  end
end
