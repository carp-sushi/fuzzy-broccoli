defmodule Todos.Util.Clock do
  @moduledoc false
  @doc "The current UTC timestamp truncated to seconds."
  def now do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end
end
