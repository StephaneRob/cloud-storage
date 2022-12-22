defmodule Sendup.Storage do
  alias Sendup.Uploads.Upload

  @callback presign_url(uploader :: module(), upload :: Upload.t()) ::
              {:ok, binary()} | {:error, binary()}
  @callback delete(upload :: Upload.t()) :: {:ok, any()} | {:error, binary()}

  def presign_url(uploader, upload) do
    module(uploader.storage()).presign_url(uploader, upload)
  end

  def delete(upload) do
    module(upload.storage).delete(upload)
  end

  defp module(:s3), do: Sendup.Storage.S3
  defp module(_), do: raise("Not implemented")
end
