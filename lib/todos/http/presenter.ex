defmodule Todos.Http.Presenter do
  @moduledoc """
  Sends use case results in a http response with the appropriate http status code.
  """
  alias Todos.Http.Response

  @doc " Handle use case result."
  def reply(:ok, conn),
    do: Response.no_content(conn)

  # Handle use case success (200, 201)
  def reply({:ok, data}, conn) do
    if conn.method == "POST" do
      Response.send_json(conn, data, 201)
    else
      Response.send_json(conn, data)
    end
  end

  # Handle use case failure (400)
  def reply({:error, message}, conn) do
    Response.send_json(conn, %{error: %{message: message}}, 400)
  end

  # Handle use case failure (4xx, 5xx)
  def reply({:error, message, status}, conn) do
    Response.send_json(
      conn,
      %{error: %{message: message}},
      http_status(status)
    )
  end

  # Convert use case status to http status
  defp http_status(status) do
    case status do
      :invalid_args -> 400
      :forbidden -> 403
      :not_found -> 404
      :todo -> 501
      :unavailable -> 503
      _ -> 500
    end
  end
end
