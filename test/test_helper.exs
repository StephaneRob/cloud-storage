Application.put_env(:sendup, Sendup.Dummy.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "Hu4qQN3iKzTV4fJxhorPQlA/osH9fAMtbtjVS58PFgfw3ja5Z18Q/WSNR9wP4OfW",
  live_view: [signing_salt: "hMegieSe"],
  render_errors: [view: Sendup.Dummy.ErrorView],
  check_origin: false,
  pubsub_server: Sendup.Dummy.PubSub
)

defmodule Sendup.Dummy.ErrorView do
  def render(template, assigns) do
    IO.inspect(assigns)
    Phoenix.Controller.status_message_from_template(template)
  end
end

defmodule Sendup.Dummy.Router do
  use Phoenix.Router
  import Sendup.Router

  scope "/user" do
    sendup_routes("/avatar_uploads", Sendup.MyUploader.Controller, as: :my_uploader)
  end
end

defmodule Sendup.Dummy.Endpoint do
  use Phoenix.Endpoint, otp_app: :sendup

  plug Plug.Session,
    store: :cookie,
    key: "_session_key",
    signing_salt: "3zu2hv++7TNPHD"

  plug Sendup.Dummy.Router
end

Supervisor.start_link(
  [
    {Phoenix.PubSub, name: Sendup.Dummy.PubSub, adapter: Phoenix.PubSub.PG2},
    Sendup.Dummy.Endpoint
  ],
  strategy: :one_for_one
)

Sendup.Repo.start_link([])
ExUnit.start()
