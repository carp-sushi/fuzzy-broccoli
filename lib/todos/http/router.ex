defmodule Todos.Http.Router do
  @moduledoc """
  Maps authorized HTTP requests to use cases.
  """
  use Plug.Router

  alias Todos.Http.{Authorize, Controller, Response, Validate}
  alias Todos.UseCase.Task.{CreateTask, DeleteTask, GetTask, ListTasks, UpdateTask}
  alias Todos.UseCase.Story.{CreateStory, DeleteStory, GetStory, ListStories, UpdateStory}

  plug(:match)
  plug(Authorize)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  # Allow users to create stories.
  post "/stories" do
    case Validate.create_story_request(conn) do
      {:ok, args} -> Controller.execute(conn, CreateStory, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end

  # Allow users to list their stories.
  get "/stories" do
    # TODO: paging...
    # conn
    # |> fetch_query_params([:limit, :offset])
    # |> tap(fn conn -> Logger.debug("Got query params = #{inspect(conn.query_params)}") end)
    # |> Controller.execute(ListStories)
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

  # Allow users to update their stories.
  patch "/stories/:story_id" do
    conn
    |> Validate.update_story_request(%{story_id: story_id})
    |> case do
      {:ok, args} -> Controller.execute(conn, UpdateStory, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end

  # Allow users to get tasks for stories.
  get "/stories/:story_id/tasks" do
    Controller.execute(conn, ListTasks, %{story_id: story_id})
  end

  # Allow users to create tasks for stories.
  post "/stories/:story_id/tasks" do
    conn
    |> Validate.create_task_request(%{story_id: story_id})
    |> case do
      {:ok, args} -> Controller.execute(conn, CreateTask, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end

  # Allow users to get individual tasks for stories.
  get "/stories/:story_id/tasks/:task_id" do
    Controller.execute(conn, GetTask, %{story_id: story_id, task_id: task_id})
  end

  # Allow users to delete individual tasks for stories.
  delete "/stories/:story_id/tasks/:task_id" do
    Controller.execute(conn, DeleteTask, %{story_id: story_id, task_id: task_id})
  end

  # Allow users to update tasks for stories.
  patch "/stories/:story_id/tasks/:task_id" do
    conn
    |> Validate.update_task_request(%{story_id: story_id, task_id: task_id})
    |> case do
      {:ok, args} -> Controller.execute(conn, UpdateTask, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
