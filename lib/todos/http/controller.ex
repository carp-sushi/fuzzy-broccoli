defmodule Todos.Http.Controller do
  @moduledoc """
  Executes use cases using  execution contexts created from http requests.
  """
  alias Todos.Http.Presenter
  require Logger

  @doc "Execute a use case and send the result as json."
  def execute(conn, use_case, args \\ %{}) do
    # ensure blockchain address from conn.assigns overrides any value provided in args.
    Map.merge(args, principal(conn.assigns))
    |> tap(&debug_args/1)
    |> use_case.execute()
    |> Presenter.reply(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      {:error, "internal error: see logs for details", :internal_error} |> Presenter.reply(conn)
  end

  # Reduce plug assignments to only the authorized blockchain address before passing to use cases.
  defp principal(assigns) do
    assigns
    |> Map.filter(fn {key, _} ->
      key === :blockchain_address
    end)
  end

  # Log request args in debug mode.
  defp debug_args(args),
    do: Logger.debug("use case args = #{inspect(args)}")
end
