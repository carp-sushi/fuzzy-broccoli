defmodule Todos.Http.Router do
  @moduledoc """
  Maps authorized HTTP requests to use cases.
  """
  use Plug.Router

  alias Todos.Http.Authorize
  alias Todos.Http.{Authorize, Controller, Response}
  alias Todos.Http.Validate

  alias Todos.UseCase.Task.ListTasks
  alias Todos.UseCase.Story.{CreateStory, DeleteStory, GetStory, ListStories}

  plug(:match)
  plug(Authorize)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  # Allow users to create stories.
  post "/stories" do
    case Validate.create_story_args(conn) do
      {:ok, args} -> Controller.execute(conn, CreateStory, args)
      {:error, error} -> Response.send_json(conn, %{error: error}, 400)
    end
  end

  # Allow users to list their stories.
  get "/stories" do
    Controller.execute(conn, ListStories)
  end

  # Allow users to get single stories.
  get "/stories/:story_id" do
    Controller.execute(conn, GetStory, %{story_id: story_id})
  end

  # Allow users to delete their stories.
  delete "/stories/:story_id" do
    Controller.execute(conn, DeleteStory, %{story_id: story_id})
  end

  # Allow users to get tasks for stories.
  get "/stories/:story_id/tasks" do
    Controller.execute(conn, ListTasks, %{story_id: story_id})
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
