defmodule Todos.Http.Authorize do
  @moduledoc """
  Extracts, validates, and assigns blockchain address headers from requests.
  """
  import Plug.Conn

  alias Todos.Http.Response
  alias Todos.Util.Validate

  # Read authorizaiton header key from config.
  @auth_header Application.compile_env(:todos, :auth_header)

  @doc false
  def init(opts), do: opts

  @doc "Check for and assign blockchain address from header."
  def call(conn, _opts) do
    case get_auth_header(conn) do
      nil -> Response.unauthorized(conn)
      blockchain_address -> validate_and_assign_address(conn, blockchain_address)
    end
  end

  # Get an account blockchain address from an authorization header.
  defp get_auth_header(conn) do
    case get_req_header(conn, @auth_header) do
      [value] -> value
      _ -> nil
    end
  end

  # Validate header value found in request and assign for upstream use.
  defp validate_and_assign_address(conn, blockchain_address) do
    %{blockchain_address: blockchain_address}
    |> Validate.blockchain_address_params()
    |> case do
      {:ok, data} -> assign(conn, :blockchain_address, data.blockchain_address)
      _ -> Response.unauthorized(conn)
    end
  end
end
