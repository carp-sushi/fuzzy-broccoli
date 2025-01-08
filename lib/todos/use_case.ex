defmodule Todos.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @callback execute(args :: map) ::
              :ok
              | {:ok, map}
              | {:error, any}
              | {:error, any, atom}
end
