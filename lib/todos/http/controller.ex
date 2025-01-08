defmodule Todos.Http.Controller do
  @moduledoc """
  Executes use cases using  execution contexts created from http requests.
  """
  alias Todos.Http.Response
  require Logger

  @doc "Execute a use case and send the result as json."
  def execute(conn, use_case, args \\ %{}) do
    Map.merge(args, conn.assigns)
    |> use_case.execute()
    |> reply(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      {:error, "internal error: see logs for details", :internal_error} |> reply(conn)
  end

  # Use case success (204).
  defp reply(:ok, conn),
    do: Response.no_content(conn)

  # Use case success (200, 201).
  defp reply({:ok, data}, conn) do
    if conn.method == "POST" do
      Response.send_json(conn, data, 201)
    else
      Response.send_json(conn, data)
    end
  end

  # Use case failure (400)
  defp reply({:error, message}, conn) do
    Response.send_json(conn, %{error: %{message: message}}, 400)
  end

  # Use case failure (4xx, 5xx)
  defp reply({:error, message, status}, conn) do
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
      :not_found -> 404
      :todo -> 501
      :unavailable -> 503
      _ -> 500
    end
  end
end
