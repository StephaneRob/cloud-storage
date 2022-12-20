defmodule Sendup.Repo.Migrations.AddAvatarToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :avatar, :string
    end

    execute """
    CREATE OR REPLACE FUNCTION users_avatar_notify() RETURNS trigger AS $$
    DECLARE
      channel text;
      notice json;
    BEGIN
      IF coalesce(NEW.avatar, '') != coalesce(OLD.avatar, '') THEN
        INSERT INTO sendup_upload_logs (old_key, new_key, inserted_at, updated_at) VALUES (OLD.avatar, NEW.avatar, NOW(), NOW());
      END IF;
      RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER users_avatar_notify_trigger
    AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW EXECUTE PROCEDURE users_avatar_notify();
    """
  end

  def down do
    execute "DROP TRIGGER IF EXISTS users_avatar_notify_trigger ON users"
    execute "DROP FUNCTION IF EXISTS users_avatar_notify();"

    alter table(:users) do
      remove :avatar, :string
    end
  end
end
