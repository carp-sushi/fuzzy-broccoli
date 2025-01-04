defmodule Todos.Data.Schema.Task do
  @moduledoc """
  SQL mapper for the `tasks` table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Todos.Data.Schema.Story
  alias Todos.Dto

  # Define type
  @type t() :: %__MODULE__{}

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "tasks" do
    field(:name, :string)
    field(:status, Ecto.Enum, values: [:todo, :done])
    field(:deleted_at, :naive_datetime)
    belongs_to(:story, Story, type: Ecto.Nanoid)
    timestamps()
  end

  @doc "Validate task changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:story_id, :name, :status, :deleted_at])
    |> validate_required([:story_id, :name, :status])
    |> validate_length(:name, max: 100)
    |> validate_inclusion(:status, [:todo, :done])
    |> foreign_key_constraint(:story_id)
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
