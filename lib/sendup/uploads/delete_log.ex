defmodule Sendup.Uploads.DeleteLog do
  use Ecto.Schema

  @type t :: %__MODULE__{
          uploads: list()
        }

  schema "sendup_upload_delete_logs" do
    field :uploads, {:array, :map}, default: []
    field :status, Ecto.Enum, values: [:pending, :failed, :completed], default: :pending

    timestamps(type: :utc_datetime)
  end
end
