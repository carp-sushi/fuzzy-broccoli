import Config

# Repo setup
config :todos,
  ecto_repos: [Todos.Repo]

# Base configuration (defaults)
config :todos,
  network_prefix: System.get_env("NETWORK_PREFIX") || "pb",
  auth_header: "x-account-address",
  max_records: 1000,
  uri_base: "/todos/api/v1"

# Configure nanoid size and alphabet.
config :nanoid,
  size: 21,
  alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ"

# Load environment configuration.
import_config "#{config_env()}.exs"
