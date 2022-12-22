defmodule Sendup.RouterTest do
  use Sendup.DataCase, async: true
  import Phoenix.ConnTest

  defmodule MyappRouter do
    use Phoenix.Router
    import Sendup.Router

    scope "/whatever" do
      sendup_routes("/uploads", Sendup.MyUploader.Controller, as: :myuploads)
    end
  end

  test "should add routes to router" do
    assert MyappRouter.Helpers.myuploads_path(build_conn(), :create) == "/whatever/uploads"

    assert MyappRouter.Helpers.myuploads_path(build_conn(), :update, "ref") ==
             "/whatever/uploads/ref"
  end
end
