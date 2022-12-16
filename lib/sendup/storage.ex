defmodule Sendup.Storage do
  alias Sendup.Uploads.Upload

  @callback presign_url(uploader :: module(), upload :: Upload.t()) ::
              {:ok, binary()} | {:error, binary()}

  def presign_url(uploader, upload) do
    uploader.storage().presign_url(uploader, upload)
  end
end
