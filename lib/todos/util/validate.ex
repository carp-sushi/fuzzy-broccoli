defmodule Todos.Util.Validate do
  @moduledoc """
  Validation helpers
  """
  import Ecto.Changeset

  # Read blockchain network prefix from config.
  @network_prefix Application.compile_env(:todos, :network_prefix)

  @doc "Validate a blockhain address"
  def blockchain_address(changeset) do
    changeset
    |> validate_required([:blockchain_address])
    |> validate_length(:blockchain_address, min: 41, max: 61)
    |> validate_address_prefix()
  end

  # "Validate blockchain address prefix."
  defp validate_address_prefix(changeset) do
    case get_field(changeset, :blockchain_address) do
      nil -> changeset
      address -> validate_address_prefix(changeset, address)
    end
  end

  # Validate blockchain address prefix.
  defp validate_address_prefix(changeset, address) do
    case String.starts_with?(address, @network_prefix) do
      true -> changeset
      false -> add_error(changeset, :blockchain_address, "must have prefix: #{@network_prefix}")
    end
  end
end
