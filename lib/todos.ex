defmodule Todos do
  @moduledoc false
  use Application
  require Logger

  @port Application.compile_env(:todos, :http_port, 8080)

  @impl true
  def start(_type, _args) do
    Logger.info("Starting the todos service on port #{@port}")

    Supervisor.start_link(
      [Todos.Repo, {Plug.Cowboy, scheme: :http, plug: Todos.Plug, options: [port: @port]}],
      strategy: :one_for_one,
      name: Todos.Supervisor
    )
  end
end
