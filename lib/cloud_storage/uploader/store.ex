defmodule CloudStorage.Uploader.Store do
  defmacro __using__(options) do
    quote do
      @options unquote(options)

      @impl true
      def bucket do
        @options[:bucket] || Application.fetch_env!(:cloud_storage, :default_bucket)
      end

      @impl true
      def storage_dir(_) do
        @options[:storage_dir] ||
          Application.get_env(:cloud_storage, :default_storage_dir, "uploads")
      end

      @impl true
      def storage do
        @options[:storage] ||
          Application.get_env(:cloud_storage, :default_storage, :s3)
      end

      @impl true
      def asset_host do
        @options[:asset_host] ||
          Application.fetch_env!(:cloud_storage, :default_asset_host)
      end

      @impl true
      def expires_in do
        @options[:expires_in] ||
          Application.get_env(:cloud_storage, :default_expires_in, 600)
      end

      defoverridable bucket: 0, storage_dir: 1, asset_host: 0
    end
  end
end
