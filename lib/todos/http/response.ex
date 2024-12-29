defmodule Todos.Http.Response do
  @moduledoc "HTTP response helper."
  import Plug.Conn

  @doc "No content success helper."
  def no_content(conn) do
    send_resp(conn, 204, "")
  end

  @doc "Not found error helper."
  def not_found(conn) do
    send_json(conn, %{error: %{message: "not found"}}, 404)
    |> halt
  end

  @doc "Unauthorized request error helper."
  def unauthorized(conn) do
    send_json(conn, %{error: %{message: "unauthorized"}}, 401)
    |> halt
  end

  @doc "Encode data to JSON and send as a HTTP response."
  def send_json(conn, data, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
