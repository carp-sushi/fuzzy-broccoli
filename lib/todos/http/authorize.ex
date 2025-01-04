defmodule Todos.Http.Authorize do
  @moduledoc """
  Extracts, validates, and assigns blockchain address headers from requests.
  """
  import Plug.Conn

  alias Todos.Http.Response
  alias Todos.Util.Validate

  require Logger

  # Read header names from config.
  @user_header Application.compile_env(:todos, :user_header)
  @group_header Application.compile_env(:todos, :group_header)

  @doc false
  def init(opts), do: opts

  @doc "Check for and assign blockchain address from header."
  def call(conn, _opts) do
    case auth_header(conn) do
      nil -> Response.unauthorized(conn)
      addr -> validate_and_assign_address(conn, addr)
    end
  end

  @doc "Get blockchain address header."
  def auth_header(conn) do
    get_header(conn, @group_header) || get_header(conn, @user_header)
  end

  # Get a single header value.
  defp get_header(conn, name) do
    case get_req_header(conn, name) do
      [value] -> value
      _ -> nil
    end
  end

  # Validate header value found in request and assign for upstream use.
  defp validate_and_assign_address(conn, addr) do
    %{blockchain_address: addr}
    |> Validate.blockchain_address_params()
    |> case do
      {:ok, data} -> assign(conn, :blockchain_address, data.blockchain_address)
      _ -> Response.unauthorized(conn)
    end
  end
end
