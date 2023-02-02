defmodule Mix.Tasks.CloudStorage.Install do
  @moduledoc """
  # TODO
  """

  use Mix.Task
  import Mix.Generator
  alias CloudStorage.Utils

  @impl true
  def run(_) do
    otp_app = Mix.Phoenix.otp_app()

    repo =
      Application.get_env(:cloud_storage, :repo) ||
        Module.concat([Macro.camelize("#{otp_app}"), "Repo"])

    priv = Application.get_env(otp_app, repo)[:priv] || "priv/repo/"
    migration_path = "#{priv}migrations/#{Utils.timestamp()}_create_cloud_storage_uploads.exs"
    source_path = Application.app_dir(:cloud_storage, "priv/templates/migration.exs")
    copy_template(source_path, migration_path, repo: repo)
  end
end
