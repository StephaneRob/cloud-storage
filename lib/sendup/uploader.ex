defmodule Sendup.Uploader do
  @callback bucket() :: binary()
  @callback storage() :: module()
  @callback storage_dir(scope :: map()) :: binary()
  @callback asset_host() :: binary()
  @callback expires_in() :: binary()

  defmacro __using__(options) do
    quote do
      @behaviour Sendup.Uploader

      use Sendup.Uploader.Store, unquote(options)
      use Sendup.Uploader.Controller
      use Sendup.Uploader.Type
    end
  end
end
