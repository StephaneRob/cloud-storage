defmodule Sendup.Uploads do
  alias Sendup.Uploads.Upload

  def create_upload(attrs \\ %{}) do
    %Upload{}
    |> Upload.changeset(attrs)
    |> repo().insert()
  end

  def mark_upload_as_uploaded(upload) do
    upload
    |> Ecto.Changeset.change(%{uploaded: true})
    |> repo().update()
  end

  def get_upload(reference) do
    repo().get(Upload, reference)
  end

  defp repo do
    Application.fetch_env!(:sendup, :repo)
  end

  def upload_key(storage_dir, reference, extension) do
    "#{storage_dir}/#{reference}#{extension}"
  end
end
