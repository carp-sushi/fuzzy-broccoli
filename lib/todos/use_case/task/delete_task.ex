defmodule Todos.UseCase.Task.DeleteTask do
  @moduledoc """
  Delete a task.
  """
  use Todos.Data.Keeper
  alias Todos.UseCase.Task.GetTask

  require Logger

  @behaviour Todos.UseCase
  def execute(args) do
    case GetTask.execute(args) do
      {:ok, %{task: task}} -> delete_task(task.id)
      error -> error
    end
  end

  # Delete a task and return
  defp delete_task(task_id) do
    result = task_keeper().delete_task(task_id)
    Logger.debug("delete task result = #{inspect(result)}")
    :no_content
  end
end
