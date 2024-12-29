# Set the sandbox ownership mode. This ensures that only a single connection is used for each test.
Ecto.Adapters.SQL.Sandbox.mode(Todos.Repo, :manual)
ExUnit.start()
