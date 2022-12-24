defmodule CloudStorage.Uploader do
  @callback bucket() :: binary()
  @callback storage() :: module()
  @callback storage_dir(scope :: map()) :: binary()
  @callback asset_host() :: binary()
  @callback expires_in() :: binary()

  defmacro __using__(options) do
    quote do
      @behaviour CloudStorage.Uploader

      use CloudStorage.Uploader.Store, unquote(options)
      use CloudStorage.Uploader.Controller
      use CloudStorage.Uploader.Type
    end
  end
end
