defmodule Todos.UseCase.Args do
  @moduledoc """
  Gets parameter sets from use case input args.
  """

  @doc "Get a required argument value."
  def get(args, key, default \\ nil) do
    case Map.get(args, key) || default do
      nil -> fail("missing required arg: #{key}")
      value -> pure(value)
    end
  end

  @doc "Get a tuple of required argument values."
  def take(args, keys) do
    keys
    |> Enum.map(fn key -> get(args, key) end)
    |> build_tuple(keys)
  end

  # Build a tuple if all argument values were found.
  defp build_tuple(values, keys) do
    if Enum.any?(values, fn t -> is_error?(t) end) do
      fail("missing required args: #{inspect(keys)}")
    else
      Enum.reduce(values, {:ok}, fn {:ok, value}, acc ->
        Tuple.insert_at(acc, tuple_size(acc), value)
      end)
    end
  end

  # error helper
  defp is_error?({:error, _}), do: true
  defp is_error?(_), do: false

  # result helpers
  defp pure(value), do: {:ok, value}
  defp fail(error), do: {:error, error}
end
