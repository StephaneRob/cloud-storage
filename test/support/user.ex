defmodule CloudStorage.User do
  use Ecto.Schema

  schema "users" do
    field :name
    field :avatar

    timestamps()
  end
end
