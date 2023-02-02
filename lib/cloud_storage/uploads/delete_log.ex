defmodule CloudStorage.Uploads.DeleteLog do
  @moduledoc """
  # TODO
  """

  use Ecto.Schema

  @type t :: %__MODULE__{
          uploads: list()
        }

  schema "cloud_storage_upload_delete_logs" do
    field :uploads, {:array, :map}, default: []

    timestamps(type: :utc_datetime)
  end
end
