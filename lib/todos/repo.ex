defmodule Todos.Repo do
  @moduledoc """
  Postgres database repository for dApp.
  """
  use Ecto.Repo,
    otp_app: :todos,
    adapter: Ecto.Adapters.Postgres
end
