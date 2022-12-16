defmodule Sendup.DefaultUploader do
  use Sendup.Uploader
end

defmodule Sendup.CustomUploader do
  use Sendup.Uploader, bucket: "app-bucket", storage_dir: "app-dir", asset_host: "https://app.com"
end

defmodule Sendup.RuntimeUploader do
  use Sendup.Uploader

  @impl true
  def storage_dir(_) do
    Sendup.Utils.timestamp() <> "/uploads"
  end

  @impl true
  def asset_host do
    "https://runtime.com"
  end
end

defmodule Sendup.UploaderTest do
  use Sendup.DataCase, async: true
  alias Sendup.{DefaultUploader, CustomUploader, RuntimeUploader}

  describe "setup default uploader" do
    test "should have default options" do
      assert DefaultUploader.storage_dir(%{}) == "myuploads"
      assert DefaultUploader.bucket() == "mybucket"
      assert DefaultUploader.asset_host() == "https://mycdn.com"
    end
  end

  describe "Custom uploader" do
    test "should have default options" do
      assert CustomUploader.storage_dir(%{}) == "app-dir"
      assert CustomUploader.bucket() == "app-bucket"
      assert CustomUploader.asset_host() == "https://app.com"
    end
  end

  describe "Runtime uploader" do
    test "should have default options" do
      assert RuntimeUploader.storage_dir(%{}) =~ ~r/[0-9]{14}\/uploads/
      assert RuntimeUploader.bucket() == "mybucket"
      assert RuntimeUploader.asset_host() == "https://runtime.com"
    end
  end
end
