Application.put_env(:cloud_storage, CloudStorage.Dummy.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "Hu4qQN3iKzTV4fJxhorPQlA/osH9fAMtbtjVS58PFgfw3ja5Z18Q/WSNR9wP4OfW",
  live_view: [signing_salt: "hMegieSe"],
  render_errors: [view: CloudStorage.Dummy.ErrorView],
  check_origin: false,
  pubsub_server: CloudStorage.Dummy.PubSub
)

defmodule CloudStorage.Dummy.ErrorView do
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

defmodule CloudStorage.Dummy.Router do
  use Phoenix.Router
  import CloudStorage.Router

  scope "/user" do
    cloud_storage_routes("/avatar_uploads", CloudStorage.MyUploader.Controller, as: :my_uploader)
  end
end

defmodule CloudStorage.Dummy.Endpoint do
  use Phoenix.Endpoint, otp_app: :cloud_storage

  plug Plug.Session,
    store: :cookie,
    key: "_session_key",
    signing_salt: "3zu2hv++7TNPHD"

  plug CloudStorage.Dummy.Router
end

Supervisor.start_link(
  [
    {Phoenix.PubSub, name: CloudStorage.Dummy.PubSub, adapter: Phoenix.PubSub.PG2},
    CloudStorage.Dummy.Endpoint
  ],
  strategy: :one_for_one
)

CloudStorage.Repo.start_link([])
ExUnit.start()
