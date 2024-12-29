defmodule Todos.UseCase.Story.ListStories do
  @moduledoc """
  Get stories for a blockchain address.
  """
  use Todos.Data.Keeper

  @behaviour Todos.UseCase
  def execute(args) do
    Todos.UseCase.Args.validate(args, [:blockchain_address], fn ->
      dtos = stories().list(args.blockchain_address) |> Enum.map(&Todos.Dto.from_schema/1)
      {:ok, %{stories: dtos}}
    end)
  end
end
