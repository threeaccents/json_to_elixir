import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :elixir_to_json, ETJ.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "elixir_to_json_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_to_json, ETJWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ci7vX2QQpXKCAP4r1sOJnD98ql8KtK0F8QhSE8M8nk5+AMk6hRbg7yGcaA8jcKw/",
  server: false

# In test we don't send emails.
config :elixir_to_json, ETJ.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
