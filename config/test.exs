import Config

# Test database config:
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
#
config :todos, Todos.Repo,
  username: "postgres",
  password: "password1",
  hostname: "localhost",
  database: "todos_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 4

# Test overrides
config :todos,
  network_prefix: "tp",
  max_records: 100

# Print warnings and errors during testing
config :logger, level: :warning
