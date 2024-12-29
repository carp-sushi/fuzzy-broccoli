import Config

# Dev database config
config :todos, Todos.Repo,
  database: "todos_dev",
  username: "postgres",
  password: "password1",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 4

# Dev overrides
config :todos,
  network_prefix: "tp",
  max_records: 100
