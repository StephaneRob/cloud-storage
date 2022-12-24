defmodule CloudStorage.UploadsTest do
  use CloudStorage.DataCase, async: true
  import CloudStorage.Factory
  alias CloudStorage.Uploads

  describe "create/1" do
    @valid_params %{
      filename: "test.jpg",
      size: 1024,
      type: "image/jpg",
      key: "whatever/coucou.jpg",
      bucket: "mybucket"
    }
    test "must create an upload w/ valid params" do
      assert {:ok, upload} = Uploads.create_upload(@valid_params)
      assert upload.filename == "test.jpg"
      assert upload.size == 1024
      assert upload.type == "image/jpg"
      assert upload.key == "whatever/coucou.jpg"
    end

    @invalid_params %{}
    test "must return invalid changeset w/ invalid params" do
      assert {:error, changeset} = Uploads.create_upload(@invalid_params)
      refute changeset.valid?

      assert changeset.errors == [
               {:filename, {"can't be blank", [validation: :required]}},
               {:type, {"can't be blank", [validation: :required]}},
               {:key, {"can't be blank", [validation: :required]}},
               {:size, {"can't be blank", [validation: :required]}},
               {:bucket, {"can't be blank", [validation: :required]}}
             ]
    end
  end

  describe "mark_as_uploaded/1" do
    test "must create an upload w/ valid params" do
      initial_upload = insert!(:upload)
      refute initial_upload.uploaded
      assert {:ok, upload} = Uploads.mark_as_uploaded(initial_upload)
      [uploaded_upload] = CloudStorage.Repo.all(CloudStorage.Uploads.Upload)
      assert uploaded_upload.reference == upload.reference
      assert uploaded_upload.reference == initial_upload.reference
      assert upload.uploaded
      assert uploaded_upload.uploaded
    end
  end
end
