defmodule <%= inspect @repo %>.Migrations.<%= @migration_name %> do
  use Ecto.Migration

  def up do
    alter table(:<%= @table %>) do
      add :<%= @field %>, :string
    end

    execute """
    CREATE OR REPLACE FUNCTION <%= @table %>_<%= @field %>_notify() RETURNS trigger AS $$
    DECLARE
      channel text;
      notice json;
    BEGIN
      IF coalesce(NEW.<%= @field %>, '') != coalesce(OLD.<%= @field %>, '') THEN
        INSERT INTO sendup_upload_logs (old_key, new_key, inserted_at, updated_at) VALUES (OLD.<%= @field %>, NEW.<%= @field %>, NOW(), NOW());
      END IF;
      RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER <%= @table %>_<%= @field %>_notify_trigger
    AFTER INSERT OR UPDATE OR DELETE ON <%= @table %>
    FOR EACH ROW EXECUTE PROCEDURE <%= @table %>_<%= @field %>_notify();
    """
  end

  def down do
    execute "DROP TRIGGER IF EXISTS <%= @table %>_<%= @field %>_notify_trigger ON <%= @table %>"
    execute "DROP FUNCTION IF EXISTS <%= @table %>_<%= @field %>_notify();"

    alter table(:<%= @table %>) do
      remove :<%= @field %>, :string
    end
  end
end