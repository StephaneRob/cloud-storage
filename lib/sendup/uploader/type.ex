defmodule Sendup.Uploader.Type do
  defmacro __using__(_) do
    quote do
      defmodule Type do
        use Ecto.Type

        @uploader __MODULE__ |> Module.split() |> Enum.drop(-1) |> Module.concat()

        @impl true
        def type, do: :string

        @impl true
        def cast(key) when is_binary(key) do
          build_upload(key)
        end

        def cast(object), do: {:ok, object}

        @impl true
        def load(key) do
          build_upload(key)
        end

        defp build_upload(key) do
          url = "#{@uploader.asset_host()}/#{key}"

          {:ok,
           %{
             key: key,
             url: url
           }}
        end

        @impl true
        def dump(key) when is_binary(key), do: {:ok, key}
        def dump(%{key: key}), do: {:ok, key}

        def dump(_), do: :error
      end
    end
  end
end
