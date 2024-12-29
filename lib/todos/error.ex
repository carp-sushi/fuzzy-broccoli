defmodule Todos.Error do
  @moduledoc """
  Project error type
  """

  @doc "Extract error detail from an ecto changeset."
  def extract(cs) when is_nil(cs), do: %{}
  def extract(cs), do: %{message: "validation failure", details: format_errors(cs)}

  # Get ecto changeset error detail.
  defp format_errors(cs) do
    Ecto.Changeset.traverse_errors(cs, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
