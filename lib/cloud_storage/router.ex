defmodule CloudStorage.Router do
  defmacro cloud_storage_routes(path, controller, options \\ []) do
    quote bind_quoted: binding() do
      import Phoenix.Router
      put "#{path}/:reference", controller, :update, as: options[:as]
      post path, controller, :create, as: options[:as]
    end
  end
end
