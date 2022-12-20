defmodule Sendup.SchemaTest do
  use Sendup.DataCase
  import Sendup.Factory

  test "attach an avatar to a user must add line in logs" do
    user = insert!(:user)
    user |> Ecto.Changeset.change(%{avatar: "uploads/test.jpg"}) |> Sendup.Repo.update!()
    log = Sendup.Repo.all(Sendup.Uploads.Log) |> List.last()
    refute log.old_key
    assert log.new_key == "uploads/test.jpg"

    user = Sendup.Repo.one(Sendup.User)

    user
    |> Ecto.Changeset.change(%{name: "jogny", avatar: "uploads/test.jpg"})
    |> Sendup.Repo.update!()

    assert [log] == Sendup.Repo.all(Sendup.Uploads.Log)

    user |> Ecto.Changeset.change(%{avatar: nil}) |> Sendup.Repo.update()
    log = Sendup.Repo.all(Sendup.Uploads.Log) |> List.last()
    assert log.old_key == "uploads/test.jpg"
    refute log.new_key
  end
end
