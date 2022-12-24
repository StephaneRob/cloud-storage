defmodule CloudStorage.Factory do
  @moduledoc false
  alias CloudStorage.Repo

  def build(:log) do
    %CloudStorage.Uploads.Log{}
  end

  def build(:user) do
    %CloudStorage.User{
      name: "#{System.monotonic_time()}"
    }
  end

  def build(:upload) do
    %CloudStorage.Uploads.Upload{
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
