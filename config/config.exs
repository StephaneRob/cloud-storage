import Config

config :phoenix, :json_library, Jason
config :cloud_storage, ecto_repos: [CloudStorage.Repo]

config :logger, level: :warning
config :logger, :console, format: "[$level] $message\n"

config :cloud_storage, CloudStorage.Repo,
  username: System.get_env("DB_USERNAME", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  database: System.get_env("DB_DATABASE", "cloud_storage_test"),
  hostname: System.get_env("DB_HOSTNAME", "localhost"),
  port: System.get_env("DB_PORT", "5432") |> String.to_integer(),
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test/support/",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :cloud_storage, :repo, CloudStorage.Repo
config :cloud_storage, :default_asset_host, "https://mycdn.com"
config :cloud_storage, :default_bucket, "mybucket"
config :cloud_storage, :default_storage_dir, "myuploads"
