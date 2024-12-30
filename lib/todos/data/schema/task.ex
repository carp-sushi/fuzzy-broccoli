defmodule Todos.Data.Schema.Task do
  @moduledoc """
  SQL mapper for the `tasks` table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Todos.Dto
  alias Todos.Data.Schema.Story

  # Define type
  @type t() :: %__MODULE__{}

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "tasks" do
    belongs_to(:story, Story, type: Ecto.Nanoid)
    field(:name, :string)
    field(:status, :string)
    field(:deleted_at, :naive_datetime)
    timestamps()
  end

  @doc "Validate campaign changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :status, :deleted_at])
    |> validate_required([:name, :status])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_length(:status, min: 1, max: 100)
  end

  # Create a data transfer object from this schema struct.
  defimpl Dto, for: __MODULE__ do
    def from_schema(struct) do
      %{
        id: struct.id,
        name: struct.name,
        status: struct.status,
        story_id: struct.story_id
      }
    end
  end
end
