defmodule Todos.Util.Validate do
  @moduledoc """
  Validation helpers
  """
  alias Ecto.Changeset
  import Ecto.Changeset

  # Read blockchain network prefix from config.
  @network_prefix Application.compile_env(:todos, :network_prefix)

  @doc "Validate a blockhain address in a parameter map."
  def blockchain_address_params(params) do
    data = %{}
    types = %{blockchain_address: :string}
    keys = Map.keys(types)

    changeset =
      {data, types}
      |> Changeset.cast(params, keys)
      |> blockchain_address_changeset()

    if changeset.valid? do
      {:ok, Changeset.apply_changes(changeset)}
    else
      {:error, Todos.Error.extract(changeset)}
    end
  end

  @doc "Validate a blockhain address"
  def blockchain_address_changeset(changeset) do
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
