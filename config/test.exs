import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :classification, ClassificationWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "X/euNKtA5xgGDAINcWJ/rGhpifN+r/LrJox88/K356FOUPU+zmux4p0EhM78/Ino",
  server: false

# In test we don't send emails
config :classification, Classification.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
