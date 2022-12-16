defmodule Sendup.Repo do
  use Ecto.Repo,
    otp_app: :sendup,
    adapter: Ecto.Adapters.Postgres
end
