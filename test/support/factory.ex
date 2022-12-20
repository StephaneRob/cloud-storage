defmodule Sendup.Factory do
  @moduledoc false
  alias Sendup.Repo

  def build(:log) do
    %Sendup.Uploads.Log{}
  end

  def build(:user) do
    %Sendup.User{
      name: "#{System.monotonic_time()}"
    }
  end

  def build(:upload) do
    %Sendup.Uploads.Upload{
      reference: Ecto.UUID.generate(),
      key: "myuploads/#{Ecto.UUID.generate()}.jpg",
      filename: "test.jpg",
      type: "image/jpg",
      extension: ".jpg",
      size: 1024,
      bucket: "mybucket"
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
