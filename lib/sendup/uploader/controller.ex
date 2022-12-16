defmodule Sendup.Uploader.Controller do
  import Phoenix.Controller
  alias Inspect.Ecto.Changeset
  alias Sendup.Storage
  alias Sendup.Uploads
  alias Sendup.Uploads.Upload
  alias Ecto.Changeset

  defmacro __using__(_) do
    quote do
      defmodule Controller do
        @uploader __MODULE__ |> Module.split() |> Enum.drop(-1) |> Module.concat()

        use Phoenix.Controller
        alias Sendup.Uploader.Controller

        def create(conn, params) do
          Controller.create(conn, params, @uploader)
        end

        def update(conn, params) do
          Controller.update(conn, params)
        end
      end
    end
  end

  def create(conn, params, uploader) do
    with {:ok, params} <- prepare_params(params, uploader),
         {:ok, upload} <- Uploads.create_upload(params),
         {:ok, url} <- Storage.presign_url(uploader, upload) do
      json(conn, %{
        url: url,
        key: upload.key,
        reference: upload.reference
      })
    else
      {:error, %Changeset{} = changeset} -> render_changeset(conn, changeset)
    end
  end

  def update(conn, %{"reference" => reference}) do
    with %Upload{} = upload <- Uploads.get_upload(reference),
         {:ok, _} <- Uploads.mark_upload_as_uploaded(upload) do
      json(conn, %{})
    end
  end

  defp prepare_params(%{"filename" => filename} = params, uploader) when is_binary(filename) do
    storage_dir = uploader.storage_dir(params)
    reference = Ecto.UUID.generate()
    extension = Path.extname(filename)
    key = Uploads.upload_key(storage_dir, reference, extension)
    params = Map.merge(params, %{"key" => key})
    {:ok, params}
  end

  defp prepare_params(params, _), do: {:ok, params}

  defp render_changeset(conn, changeset) do
    conn
    |> Plug.Conn.put_status(422)
    |> json(%{errors: format_errors(changeset)})
  end

  defp format_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      %{
        message: msg,
        options: opts |> Enum.into(%{}, &format_opts/1)
      }
    end)
  end

  defp format_opts({key, val}) when is_map(val), do: {key, inspect(val)}
  defp format_opts({key, val}) when is_tuple(val), do: {key, inspect(val)}
  defp format_opts({key, val}), do: {key, val}
end
