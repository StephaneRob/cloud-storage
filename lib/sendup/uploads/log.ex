defmodule Sendup.Uploads.Log do
  use Ecto.Schema

  @type t :: %__MODULE__{
          old_key: binary(),
          new_key: binary()
        }

  schema "sendup_upload_logs" do
    field :old_key
    field :new_key

    timestamps(type: :utc_datetime)
  end
end
