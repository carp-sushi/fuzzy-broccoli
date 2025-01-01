defmodule Todos.Data.Keeper.TaskKeeper do
  @moduledoc """
  Data keeper for managing tasks.
  """
  alias Todos.Data.Schema.Task

  @doc "Create a new task"
  @callback create_task(map) :: {:ok, Task.t()} | {:error, any}

  @doc "Read a task"
  @callback get_task(String.t()) :: {:ok, Task.t()} | {:error, any}

  @doc "Read a list of tasks for a story."
  @callback list_tasks(String.t()) :: list(Task.t())

  @doc "Update a task."
  @callback update_task(Task.t(), map) :: {:ok, Task.t()} | {:error, any}

  @doc "Delete a task."
  @callback delete_task(String.t()) :: {non_neg_integer(), nil | [term()]}
end
