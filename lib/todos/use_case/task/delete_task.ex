defmodule Todos.UseCase.Task.DeleteTask do
  @moduledoc """
  Delete a task.
  """
  use Todos.Data.Keeper
  alias Todos.UseCase.Task.GetTask

  @behaviour Todos.UseCase
  def execute(args) do
    case GetTask.execute(args) do
      {:ok, %{task: task}} -> delete_task(task.id)
      error -> error
    end
  end

  # Delete a task and return
  defp delete_task(task_id) do
    task_keeper().delete_task(task_id)
    :no_content
  end
end
