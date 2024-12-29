defmodule Todos do
  @moduledoc false
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting the todos app...")

    Supervisor.start_link(
      [Todos.Repo, {Plug.Cowboy, scheme: :http, plug: Todos.Plug, options: [port: 8080]}],
      strategy: :one_for_one,
      name: Todos.Supervisor
    )
  end
end
