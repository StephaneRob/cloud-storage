import Config

config :phoenix, :json_library, Jason
config :sendup, ecto_repos: [Sendup.Repo]
config :sendup, :repo, Sendup.Repo

config :logger, level: :warning
config :logger, :console, format: "[$level] $message\n"

config :sendup, Sendup.Repo,
  username: System.get_env("DB_USERNAME", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  database: System.get_env("DB_DATABASE", "sendup_test"),
  hostname: System.get_env("DB_HOSTNAME", "localhost"),
  port: System.get_env("DB_PORT", "5432") |> String.to_integer(),
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test/support/",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :sendup, :default_asset_host, "https://mycdn.com"
config :sendup, :default_bucket, "mybucket"
config :sendup, :default_storage_dir, "myuploads"
