defmodule Mix.Tasks.Sendup.Install do
  use Mix.Task
  import Mix.Generator
  alias Sendup.Utils

  @impl true
  def run(_) do
    otp_app = Mix.Phoenix.otp_app()

    repo =
      Application.get_env(:sendup, :repo) || Module.concat([Macro.camelize("#{otp_app}"), "Repo"])

    priv = Application.get_env(otp_app, repo)[:priv] || "priv/repo/"
    migration_path = "#{priv}migrations/#{Utils.timestamp()}_create_sendup_uploads.exs"
    source_path = Application.app_dir(:sendup, "priv/templates/migration.exs")
    copy_template(source_path, migration_path, repo: repo)
  end
end
