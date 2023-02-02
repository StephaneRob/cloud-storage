defmodule CloudStorage.Uploads do
  @moduledoc """
  # TODO
  """

  import Ecto.Query
  alias Ecto.Multi
  alias CloudStorage.Uploads.{DeleteLog, Log, Upload}

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

  def delete_upload(upload, delete_log) do
    Multi.new()
    |> Multi.run(:delete_file, fn _, _ -> CloudStorage.Storage.delete(upload) end)
    |> Multi.delete(:delete_upload, upload)
    |> Multi.run(:update_log, fn repo, _ ->
      log = %{storage: upload.storage, bucket: upload.bucket, key: upload.key}

      query =
        from d in DeleteLog,
          where: d.id == ^delete_log.id,
          update: [
            push: [uploads: ^log]
          ]

      {updated, _} = repo.update_all(query, [])
      {:ok, updated}
    end)
    |> repo().transaction()
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

  def create_delete_log do
    %DeleteLog{}
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
    Application.fetch_env!(:cloud_storage, :repo)
  end
end
