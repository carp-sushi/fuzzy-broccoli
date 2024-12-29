defmodule Todos.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @type success ::
          :no_content
          | {:ok, data :: map}
          | {:created, data :: map}

  @type failure ::
          {:not_found, error :: any}
          | {:invalid_args, error :: any}
          | {:internal_error, error :: any}

  @callback execute(args :: map) :: success | failure
end
