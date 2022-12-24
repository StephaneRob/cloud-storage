defmodule CloudStorage.Uploader.TypeTest do
  use CloudStorage.DataCase, async: true
  alias CloudStorage.MyUploader.Type

  @object %{key: "myupload/test.jpg", url: "https://cdn.com/myupload/test.jpg"}
  @key "myupload/test.jpg"

  test "type" do
    assert Type.type() == :string
  end

  test "cast" do
    assert Type.cast(@key) == {:ok, @object}
    assert Type.cast(@object) == {:ok, @object}
  end

  test "dump" do
    assert Type.dump(@key) == {:ok, @key}
    assert Type.dump(@object) == {:ok, @key}
  end

  test "load" do
    assert Type.load(@key) == {:ok, @object}
  end
end
