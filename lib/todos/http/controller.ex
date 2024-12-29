defmodule Todos.Http.Controller do
  @moduledoc "HTTP request handler."
  alias Todos.Http.Response
  require Logger

  @doc "Execute a use case and send the result as json."
  def execute(conn, use_case, args \\ %{}) do
    conn.assigns
    |> Map.merge(args)
    |> use_case.execute()
    |> reply(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      {:internal_error, "internal error: check server logs for details"} |> reply(conn)
  end

  # Use case success (204).
  defp reply(:no_content, conn),
    do: Response.no_content(conn)

  # Use case success (200).
  defp reply({:ok, data}, conn),
    do: Response.send_json(conn, data)

  # Use case success (201).
  defp reply({:created, data}, conn),
    do: Response.send_json(conn, data, 201)

  # Use case not found (404)
  defp reply({:not_found, message}, conn) do
    Response.send_json(conn, %{error: %{message: message}}, 404)
  end

  # Use case invalid args (400)
  defp reply({:invalid_args, message}, conn) do
    Response.send_json(conn, %{error: %{message: message}}, 400)
  end

  # Use case internal error (500)
  defp reply({:internal_error, message}, conn) do
    Response.send_json(conn, %{error: %{message: message}}, 500)
  end
end
