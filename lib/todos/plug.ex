defmodule Todos.Plug do
  @moduledoc """
  Top-level plug: handles health requests or forwards to internal api routers.
  """
  use Plug.Router
  alias Todos.Http.{Response, Router}

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Read base URI from config
  @uri_base Application.compile_env(:todos, :uri_base)

  # Forward to http router.
  forward(@uri_base, to: Router)

  # Health checks.
  get "/health/*glob" do
    Response.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Response.not_found(conn)
  end
end
