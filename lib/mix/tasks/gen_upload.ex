defmodule Mix.Tasks.Sendup.Gen.Upload do
  use Mix.Task
  import Mix.Generator
  alias Sendup.Utils

  @impl true
  def run([table, field]) do
    otp_app = Mix.Phoenix.otp_app()

    repo =
      Application.get_env(:sendup, :repo) || Module.concat([Macro.camelize("#{otp_app}"), "Repo"])

    priv = Application.get_env(otp_app, repo)[:priv] || "priv/repo/"
    migration_name = "add_#{field}_to_#{table}"
    migration_path = "#{priv}migrations/#{Utils.timestamp()}_#{migration_name}.exs"
    source_path = Application.app_dir(:sendup, "priv/templates/field.exs")

    copy_template(source_path, migration_path,
      repo: repo,
      table: table,
      field: field,
      migration_name: Macro.camelize(migration_name)
    )
  end
end
