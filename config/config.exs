import Config

# Repo setup
config :todos,
  ecto_repos: [Todos.Repo]

# Base configuration (defaults)
config :todos,
  network_prefix: "pb",
  user_header: "x-account-address",
  group_header: "x-group-policy",
  max_records: 1000,
  uri_base: "/todos/api/v1"

# Configure nanoid size and alphabet.
config :nanoid,
  size: 21,
  alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ"

# Load environment configuration.
import_config "#{config_env()}.exs"
