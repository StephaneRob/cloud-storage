defmodule CloudStorage.Repo do
  use Ecto.Repo,
    otp_app: :cloud_storage,
    adapter: Ecto.Adapters.Postgres
end
