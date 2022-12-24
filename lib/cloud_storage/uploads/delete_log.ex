defmodule CloudStorage.Uploads.DeleteLog do
  use Ecto.Schema

  @type t :: %__MODULE__{
          uploads: list()
        }

  schema "cloud_storage_upload_delete_logs" do
    field :uploads, {:array, :map}, default: []

    timestamps(type: :utc_datetime)
  end
end