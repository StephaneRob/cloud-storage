defmodule CloudStorage.Storage.S3 do
  @moduledoc """
  # TODO
  """

  @behaviour CloudStorage.Storage

  @impl true
  def presign_url(uploader, upload) do
    :s3
    |> ExAws.Config.new()
    |> ExAws.S3.presigned_url(
      :put,
      uploader.bucket(),
      upload.key,
      headers: [{"content-type", upload.type}],
      expires_in: uploader.expires_in()
    )
  end

  @impl true
  def delete(upload) do
    upload.bucket
    |> ExAws.S3.delete_object(upload.key)
    |> ExAws.request()
  end
end
