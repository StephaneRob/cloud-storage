defmodule CloudStorage.Uploader.ControllerTest do
  use CloudStorage.ConnCase, async: true
  import CloudStorage.Factory

  describe "create/2" do
    test "Must create an upload and return a presigned url", %{conn: conn} do
      route = Routes.my_uploader_path(conn, :create)

      params = %{
        filename: "test.jpg",
        type: "image/jpg",
        size: 1024
      }

      conn = post(conn, route, params)
      assert response = json_response(conn, 200)
      assert response["url"] =~ "https://s3.amazonaws.com/mybucket/myuploads"
      assert Regex.match?(~r/myuploads\/.*\.jpg/, response["key"])
      [upload] = CloudStorage.Repo.all(CloudStorage.Uploads.Upload)
      assert upload.reference == response["reference"]
      assert upload.storage == :s3
    end

    test "Must return errors if missing params", %{conn: conn} do
      route = Routes.my_uploader_path(conn, :create)
      params = %{}
      conn = post(conn, route, params)
      assert response = json_response(conn, 422)

      assert response["errors"] == %{
               "filename" => [
                 %{"message" => "can't be blank", "options" => %{"validation" => "required"}}
               ],
               "key" => [
                 %{"message" => "can't be blank", "options" => %{"validation" => "required"}}
               ],
               "size" => [
                 %{"message" => "can't be blank", "options" => %{"validation" => "required"}}
               ],
               "type" => [
                 %{"message" => "can't be blank", "options" => %{"validation" => "required"}}
               ]
             }
    end
  end

  describe "update/2" do
    test "Must update an upload and mark it as uploaded", %{conn: conn} do
      old_upload = insert!(:upload)
      refute old_upload.uploaded
      route = Routes.my_uploader_path(conn, :update, old_upload.reference)
      conn = put(conn, route)
      assert json_response(conn, 200)
      [upload] = CloudStorage.Repo.all(CloudStorage.Uploads.Upload)
      assert old_upload.reference == upload.reference
      assert upload.uploaded
    end
  end
end
