defmodule Sendup.User do
  use Ecto.Schema

  schema "users" do
    field :name
    field :avatar
  end
end
