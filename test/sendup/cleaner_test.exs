defmodule Sendup.CleanerTest do
  alias Sendup.Uploads
  alias Sendup.Uploads.DeleteLog
  alias Sendup.Cleaner
  import Sendup.Factory
  use Sendup.DataCase

  test "must delete out dated uploads" do
    _u1 = insert!(:upload, bucket: "mybucket1", updated_at: ago(1))
    _u2 = insert!(:upload, bucket: "mybucket2", updated_at: ago(40), orphan: false)
    _u3 = insert!(:upload, bucket: "mybucket3", updated_at: ago(19))

    _u4 =
      insert!(:upload,
        bucket: "mybucket4",
        key: "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg",
        updated_at: ago(31)
      )

    assert Sendup.Repo.all(DeleteLog) == []
    Cleaner.handle_info(:clean, nil)
    assert [delete_log] = Sendup.Repo.all(DeleteLog)

    assert delete_log.uploads == [
             %{
               "bucket" => "mybucket4",
               "key" => "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg"
             }
           ]

    assert delete_log.status == :pending
  end

  def ago(days) do
    DateTime.utc_now() |> DateTime.add(-days, :day) |> DateTime.truncate(:second)
  end
end
