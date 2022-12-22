defmodule <%= inspect @repo %>.Migrations.CreateS3Uploads do
  use Ecto.Migration

  def change do
    create table(:sendup_uploads, primary_key: false) do
      add :reference, :uuid, primary_key: true
      add :filename, :string, null: false
      add :type, :string, null: false
      add :extension, :string, null: false
      add :key, :string, null: false
      add :uploaded, :boolean, default: false, null: false
      add :size, :integer
      add :orphan, :boolean, default: true
      add :bucket, :string, null: false
      add :storage, :string, null: false

      timestamps()
    end

    create table(:sendup_upload_delete_logs) do
      add :uploads, {:array, :map}, default: []

      timestamps()
    end

    create table(:sendup_upload_logs) do
      add :old_key, :string
      add :new_key, :string

      timestamps()
    end
  end
end