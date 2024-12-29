defmodule Todos.Http.Validate do
  @moduledoc """
  Http request validations
  """
  alias Ecto.Changeset
  import Ecto.Changeset

  @doc "Validate a blockhain address pulled from request header."
  def blockchain_address(blockchain_address) do
    data = %{}
    types = %{blockchain_address: :string}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(%{blockchain_address: blockchain_address}, keys)
      |> Todos.Util.Validate.blockchain_address()

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Todos.Error.extract(cs)}
    end
  end

  @doc "Parse arguments for creating new stories"
  def create_story_args(conn) do
    data = %{}
    types = %{name: :string, description: :string}

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, [:name, :description])
      |> validate_required([:name])
      |> validate_length(:name, min: 1, max: 100)
      |> validate_length(:description, max: 1000)

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Todos.Error.extract(cs)}
    end
  end
end
