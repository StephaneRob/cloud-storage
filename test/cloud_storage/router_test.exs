defmodule CloudStorage.RouterTest do
  use CloudStorage.DataCase, async: true
  import Phoenix.ConnTest

  defmodule MyappRouter do
    use Phoenix.Router
    import CloudStorage.Router

    scope "/whatever" do
      cloud_storage_routes "/uploads", CloudStorage.MyUploader.Controller, as: :myuploads
    end
  end

  test "should add routes to router" do
    assert MyappRouter.Helpers.myuploads_path(build_conn(), :create) == "/whatever/uploads"

    assert MyappRouter.Helpers.myuploads_path(build_conn(), :update, "ref") ==
             "/whatever/uploads/ref"
  end
end
