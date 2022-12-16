defmodule Sendup.Storage.S3 do
  @behaviour Sendup.Storage

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
end
