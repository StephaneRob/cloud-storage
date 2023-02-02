defmodule CloudStorage.Uploads.Log do
  @moduledoc """
  # TODO
  """

  use Ecto.Schema

  @type t :: %__MODULE__{
          old_key: binary(),
          new_key: binary()
        }

  schema "cloud_storage_upload_logs" do
    field :old_key
    field :new_key

    timestamps(type: :utc_datetime)
  end
end
