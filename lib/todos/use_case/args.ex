defmodule Todos.UseCase.Args do
  @moduledoc """
  Use case arguments helper functions.
  """

  @doc "Call a function if input args map contains all required keys."
  def validate(args, keys, func) do
    if is_nil(args) || missing_keys?(args, keys) do
      {:error, "missing required args: #{inspect(keys)}"}
    else
      func.()
    end
  end

  # Determine whether any of the required args values are missing.
  defp missing_keys?(args, keys) do
    Enum.any?(keys, fn key ->
      !Map.has_key?(args, key)
    end)
  end
end
