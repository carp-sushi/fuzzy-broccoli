defmodule Todos.Http.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Module under test
  alias Todos.Http.Router

  # Required auth header key
  @auth_header Application.compile_env(:todos, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "GET /stories" do
    test "returns a list of stories for a blockchain address" do
      {blockchain_address, _} = StoryUtil.mock_list_stories()
      req = conn(:get, "/stories") |> put_req_header(@auth_header, blockchain_address)
      res = Router.call(req, [])
      assert res.status == 200
    end

    test "returns a 401 with no auth header" do
      req = conn(:get, "/stories")
      res = Router.call(req, [])
      assert res.status == 401
    end

    test "returns a 401 with invalid auth header" do
      req = conn(:get, "/stories") |> put_req_header(@auth_header, Nanoid.generate())
      res = Router.call(req, [])
      assert res.status == 401
    end
  end

  describe "POST /stories" do
    test "creates new stories" do
      StoryUtil.mock_create_story()

      data = %{name: "name:#{Nanoid.generate()}"}
      body = Poison.encode!(data)

      res =
        conn(:post, "/stories", body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
        |> Router.call([])

      assert res.status == 201
    end

    test "fails when no body is sent" do
      res =
        conn(:post, "/stories")
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
        |> Router.call([])

      assert res.status == 400
    end
  end

  describe "GET /stories/:story_id" do
    test "returns an existing story" do
      story = StoryUtil.mock_get_story()
      uri = "/stories/#{story.id}"
      req = conn(:get, uri) |> put_req_header(@auth_header, story.blockchain_address)
      res = Router.call(req, [])
      assert res.status == 200
    end
  end

  describe "DELETE /stories/:story_id" do
    test "deletes an existing story" do
      story = StoryUtil.mock_delete_story()
      uri = "/stories/#{story.id}"
      req = conn(:delete, uri) |> put_req_header(@auth_header, story.blockchain_address)
      res = Router.call(req, [])
      assert res.status == 204
    end
  end

  describe "PATCH /stories/:story_id" do
    test "updates an existing story" do
      story = StoryUtil.mock_update_story()

      data = %{name: Nanoid.generate(), description: Nanoid.generate(42)}
      body = Poison.encode!(data)

      res =
        conn(:patch, "/stories/#{story.id}", body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, story.blockchain_address)
        |> Router.call([])

      assert res.status == 200
    end

    test "fails when invalid data is sent" do
      data = %{name: Nanoid.generate(101)}
      body = Poison.encode!(data)

      res =
        conn(:patch, "/stories/#{Nanoid.generate()}", body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
        |> Router.call([])

      assert res.status == 400
    end
  end

  describe "GET /stories/:story_id/tasks" do
    test "returns tasks for an existing story" do
      story = StoryUtil.mock_get_story()
      TaskUtil.mock_list_tasks(story.id)
      uri = "/stories/#{story.id}/tasks"
      req = conn(:get, uri) |> put_req_header(@auth_header, story.blockchain_address)
      res = Router.call(req, [])
      assert res.status == 200
    end
  end

  describe "POST /stories/:story_id/tasks" do
    test "creates new tasks" do
      story = StoryUtil.mock_get_story()
      TaskUtil.mock_create_task()

      data = %{name: Nanoid.generate()}
      body = Poison.encode!(data)

      res =
        conn(:post, "/stories/#{story.id}/tasks", body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, story.blockchain_address)
        |> Router.call([])

      assert res.status == 201
    end

    test "fails when no body is sent" do
      res =
        conn(:post, "/stories/#{Nanoid.generate()}/tasks")
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
        |> Router.call([])

      assert res.status == 400
    end
  end

  describe "GET /stories/:story_id/tasks/:task_id" do
    test "returns an existing task" do
      story = StoryUtil.mock_get_story()
      task = TaskUtil.mock_get_task(story.id)
      uri = "/stories/#{story.id}/tasks/#{task.id}"
      req = conn(:get, uri) |> put_req_header(@auth_header, story.blockchain_address)
      res = Router.call(req, [])
      assert res.status == 200
    end
  end

  describe "DELETE /stories/:story_id/tasks/:task_id" do
    test "deletes an existing task" do
      story = StoryUtil.mock_get_story()
      task = TaskUtil.mock_delete_task(story.id)
      uri = "/stories/#{story.id}/tasks/#{task.id}"
      req = conn(:delete, uri) |> put_req_header(@auth_header, story.blockchain_address)
      res = Router.call(req, [])
      assert res.status == 204
    end
  end

  describe "PATCH /stories/:story_id/tasks/:task_id" do
    test "updates an existing task" do
      story = StoryUtil.mock_get_story()
      task = TaskUtil.mock_update_task(story.id)

      data = %{status: "done"}
      body = Poison.encode!(data)

      uri = "/stories/#{story.id}/tasks/#{task.id}"

      res =
        conn(:patch, uri, body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, story.blockchain_address)
        |> Router.call([])

      assert res.status == 200
    end

    test "fails when invalid data is sent" do
      story_id = Nanoid.generate()
      task_id = Nanoid.generate()

      uri = "/stories/#{story_id}/tasks/#{task_id}"

      data = %{name: Nanoid.generate(101)}
      body = Poison.encode!(data)

      res =
        conn(:patch, uri, body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
        |> Router.call([])

      assert res.status == 400
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404" do
      blockchain_address = FakeData.generate_blockchain_address()
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, blockchain_address)
      res = Router.call(req, [])
      assert res.status == 404
    end
  end
end
