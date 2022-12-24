defmodule Mix.Tasks.CloudStorage.Gen.Upload do
  use Mix.Task
  import Mix.Generator
  alias CloudStorage.Utils

  @impl true
  def run([table, field]) do
    otp_app = Mix.Phoenix.otp_app()

    repo =
      Application.get_env(:cloud_storage, :repo) ||
        Module.concat([Macro.camelize("#{otp_app}"), "Repo"])

    priv = Application.get_env(otp_app, repo)[:priv] || "priv/repo/"
    migration_name = "add_#{field}_to_#{table}"
    migration_path = "#{priv}migrations/#{Utils.timestamp()}_#{migration_name}.exs"
    source_path = Application.app_dir(:cloud_storage, "priv/templates/field.exs")

    copy_template(source_path, migration_path,
      repo: repo,
      table: table,
      field: field,
      migration_name: Macro.camelize(migration_name)
    )
  end
end
