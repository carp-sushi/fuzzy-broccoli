defmodule Todos.Data.Schema.Story do
  @moduledoc """
  SQL mapper for the `stories` table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Todos.Data.Schema.Task
  alias Todos.Dto
  alias Todos.Util.Validate

  # Define type
  @type t() :: %__MODULE__{}

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "stories" do
    field(:blockchain_address, :string)
    field(:name, :string)
    field(:description, :string)
    field(:deleted_at, :naive_datetime)
    has_many(:tasks, Task)
    timestamps()
  end

  @doc "Validate campaign changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:blockchain_address, :name, :description, :deleted_at])
    |> validate_required([:blockchain_address, :name])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_length(:description, max: 1000)
    |> Validate.blockchain_address_changeset()
  end

  # Create a data transfer object from this schema struct.
  defimpl Dto, for: __MODULE__ do
    def from_schema(struct) do
      %{
        id: struct.id,
        name: struct.name,
        description: struct.description,
        blockchain_address: struct.blockchain_address
      }
    end
  end
end
