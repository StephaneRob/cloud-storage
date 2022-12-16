defmodule Sendup.Uploads.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          filename: binary(),
          type: binary(),
          extension: binary(),
          key: binary(),
          uploaded: boolean(),
          orphan: boolean(),
          size: integer()
        }

  @primary_key {:reference, Ecto.UUID, autogenerate: true}
  schema "sendup_uploads" do
    field :filename
    field :type
    field :extension
    field :key
    field :uploaded, :boolean, default: false
    field :orphan, :boolean, default: true
    field :size, :integer

    timestamps(type: :utc_datetime)
  end

  @required [:filename, :type, :key, :size]
  @optional [:uploaded, :orphan, :extension]

  def changeset(upload, attrs) do
    upload
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> set_extension()
  end

  defp set_extension(changeset) do
    filename = get_field(changeset, :filename)

    if is_binary(filename) do
      ext = Path.extname(filename)
      put_change(changeset, :extension, ext)
    else
      changeset
    end
  end
end
