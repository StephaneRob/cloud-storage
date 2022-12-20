defmodule Sendup.Uploads do
  import Ecto.Query
  alias Sendup.Uploads.{DeleteLog, Log, Upload}

  def create_upload(attrs \\ %{}) do
    %Upload{}
    |> Upload.changeset(attrs)
    |> repo().insert()
  end

  def mark_as_uploaded(upload) do
    upload
    |> Ecto.Changeset.change(%{uploaded: true})
    |> repo().update()
  end

  def mark_as_orphan(upload, orphan) do
    upload
    |> Ecto.Changeset.change(%{orphan: orphan})
    |> repo().update()
  end

  def get_upload(reference) do
    repo().get(Upload, reference)
  end

  def get_upload_by_key(key) do
    repo().get_by(Upload, key: key)
  end

  def list_logs(limit \\ 100) do
    q = from l in Log, order_by: [desc: :inserted_at], limit: ^limit
    repo().all(q)
  end

  def upload_key(storage_dir, reference, extension) do
    "#{storage_dir}/#{reference}#{extension}"
  end

  def delete_log(log) do
    repo().delete(log)
  end

  def get_last_deleted_batch do
    q = from d in DeleteLog, order_by: [desc: :inserted_at], limit: 1
    repo().one(q)
  end

  def list_deleted do
    repo().all(Deleted)
  end

  def create_delete_log(uploads) do
    %DeleteLog{uploads: Enum.map(uploads, &%{bucket: &1.bucket, key: &1.key})}
    |> repo().insert()
  end

  def to_delete(limit \\ nil) do
    q =
      from u in Upload,
        where: u.orphan and u.updated_at < ago(1, "month"),
        order_by: [desc: :inserted_at],
        limit: ^limit

    repo().all(q)
  end

  defp repo do
    Application.fetch_env!(:sendup, :repo)
  end
end
