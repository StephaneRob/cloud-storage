defmodule <%= inspect @repo %>.Migrations.CreateS3Uploads do
  use Ecto.Migration

  def change do
    create table(:sendup_uploads, primary_key: false) do
      add :reference, :uuid, primary_key: true
      add :filename, :string, null: false
      add :mime_type, :string, null: false
      add :file_extension, :string, null: false
      add :object_key, :string, null: false
      add :uploaded, :boolean, default: false, null: false
      add :size, :integer
      add :orphan, :boolean, default: true

      timestamps()
    end
  end
end