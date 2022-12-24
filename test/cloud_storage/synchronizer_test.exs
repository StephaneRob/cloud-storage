defmodule CloudStorage.SynchronizerTest do
  use CloudStorage.DataCase, async: true
  alias CloudStorage.Uploads
  alias CloudStorage.Synchronizer
  import CloudStorage.Factory

  test "must flag upload as ophan if old_key present" do
    upload = insert!(:upload, key: "upload/old_key.jpg", orphan: false)
    insert!(:log, old_key: "upload/old_key.jpg")
    Synchronizer.handle_info(:run, nil)
    new_upload = Uploads.get_upload(upload.reference)
    assert new_upload.orphan
  end

  test "must flag upload as non ophan if new_key present" do
    upload = insert!(:upload, key: "upload/new_key.jpg", orphan: true)
    insert!(:log, new_key: "upload/new_key.jpg")
    Synchronizer.handle_info(:run, nil)
    new_upload = Uploads.get_upload(upload.reference)
    refute new_upload.orphan
  end

  test "must flag uploads as non ophan and orphan respectively" do
    upload1 = insert!(:upload, key: "upload/old_key.jpg", orphan: false)
    upload2 = insert!(:upload, key: "upload/new_key.jpg", orphan: true)
    insert!(:log, new_key: "upload/new_key.jpg", old_key: "upload/old_key.jpg")
    Synchronizer.handle_info(:run, nil)

    new_upload1 = Uploads.get_upload(upload1.reference)
    assert new_upload1.orphan

    new_upload2 = Uploads.get_upload(upload2.reference)
    refute new_upload2.orphan
  end
end
