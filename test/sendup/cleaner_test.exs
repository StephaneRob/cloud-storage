defmodule Sendup.CleanerTest do
  use Sendup.DataCase
  import Sendup.Factory
  import Mock
  alias Sendup.Uploads
  alias Sendup.Uploads.DeleteLog
  alias Sendup.Cleaner

  test_with_mock "must delete out dated uploads", ExAws, request: fn _ -> {:ok, "whatever"} end do
    u1 = insert!(:upload, bucket: "mybucket1", updated_at: ago(1))
    u2 = insert!(:upload, bucket: "mybucket2", updated_at: ago(40), orphan: false)
    u3 = insert!(:upload, bucket: "mybucket3", updated_at: ago(19))

    u4 =
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
               "key" => "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg",
               "storage" => "s3"
             }
           ]

    assert_called(
      ExAws.request(%ExAws.Operation.S3{
        path: "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg",
        http_method: :delete,
        service: :s3,
        bucket: "mybucket4"
      })
    )

    assert Uploads.get_upload(u1.reference)
    assert Uploads.get_upload(u2.reference)
    assert Uploads.get_upload(u3.reference)
    refute Uploads.get_upload(u4.reference)
  end

  test_with_mock "must delete out dated uploads and flag failed", ExAws,
    request: fn
      %ExAws.Operation.S3{path: "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg"} ->
        {:error, "failed"}

      _ ->
        {:ok, "whatever"}
    end do
    u1 =
      insert!(:upload,
        bucket: "mybucket",
        key: "myuploads/126262cc-e4df-4f2b-a068-0da3cb18c6f4.jpg",
        updated_at: ago(31)
      )

    u2 =
      insert!(:upload,
        bucket: "mybucket",
        key: "myuploads/fb40d14e-5159-4810-a784-aa3f696508ee.jpg",
        updated_at: ago(31)
      )

    u3 =
      insert!(:upload,
        bucket: "mybucket",
        key: "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg",
        updated_at: ago(31)
      )

    assert Sendup.Repo.all(DeleteLog) == []
    Cleaner.handle_info(:clean, nil)
    assert [delete_log] = Sendup.Repo.all(DeleteLog)

    assert delete_log.uploads == [
             %{
               "bucket" => "mybucket",
               "key" => "myuploads/126262cc-e4df-4f2b-a068-0da3cb18c6f4.jpg",
               "storage" => "s3"
             },
             %{
               "bucket" => "mybucket",
               "key" => "myuploads/fb40d14e-5159-4810-a784-aa3f696508ee.jpg",
               "storage" => "s3"
             }
           ]

    assert_called(
      ExAws.request(%ExAws.Operation.S3{
        path: "myuploads/126262cc-e4df-4f2b-a068-0da3cb18c6f4.jpg",
        http_method: :delete,
        service: :s3,
        bucket: "mybucket"
      })
    )

    assert_called(
      ExAws.request(%ExAws.Operation.S3{
        path: "myuploads/fb40d14e-5159-4810-a784-aa3f696508ee.jpg",
        http_method: :delete,
        service: :s3,
        bucket: "mybucket"
      })
    )

    assert_called(
      ExAws.request(%ExAws.Operation.S3{
        path: "myuploads/68582cf3-53b7-4c49-99e3-4973f6e8b91d.jpg",
        http_method: :delete,
        service: :s3,
        bucket: "mybucket"
      })
    )

    refute Uploads.get_upload(u1.reference)
    refute Uploads.get_upload(u2.reference)
    assert Uploads.get_upload(u3.reference)
  end

  def ago(days) do
    DateTime.utc_now() |> DateTime.add(-days, :day) |> DateTime.truncate(:second)
  end
end
