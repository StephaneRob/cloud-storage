defmodule CloudStorage.SchemaTest do
  use CloudStorage.DataCase, async: true
  import CloudStorage.Factory

  test "attach an avatar to a user must add line in logs" do
    user = insert!(:user)
    user |> Ecto.Changeset.change(%{avatar: "uploads/test.jpg"}) |> CloudStorage.Repo.update!()
    log = CloudStorage.Repo.all(CloudStorage.Uploads.Log) |> List.last()
    refute log.old_key
    assert log.new_key == "uploads/test.jpg"

    user = CloudStorage.Repo.one(CloudStorage.User)

    user
    |> Ecto.Changeset.change(%{name: "jogny", avatar: "uploads/test.jpg"})
    |> CloudStorage.Repo.update!()

    assert [log] == CloudStorage.Repo.all(CloudStorage.Uploads.Log)

    user |> Ecto.Changeset.change(%{avatar: nil}) |> CloudStorage.Repo.update()
    log = CloudStorage.Repo.all(CloudStorage.Uploads.Log) |> List.last()
    assert log.old_key == "uploads/test.jpg"
    refute log.new_key
  end
end
