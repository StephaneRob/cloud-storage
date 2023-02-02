# CloudStorage

Direct upload with Elixir / Phoenix

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloud_storage` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloud_storage, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/cloud_storage>.

## How it works?

CloudStorage is a direct upload backend and it's compatible with multiple storage.
The idea is to call an API endpoint to get a presigned url, upload the file directly to the storage and let know the backend that the file is correclty uploaded.

The response from the inital call to get presigned url looks like this:

```json
{
  "url": "...presigned_url",
  "key": "object_key",
  "reference": "unique reference for the upload"
}
```

The object key is the value that we want to save into our model.

### Private files

### What about orphan uploads?

**What is an orphan upload?**

Orphan upload is a remote file not used anymore in any of your upload field.

**How CloudStorage handle them?**

Uploads are tracked using Postgresql trigger function. Each time there is a change on an upload field (ex: avatar), cloud_storage will take care of referencing/dereferencing the corresponding upload.
Orphan uploads not updated in the last month are automatically deleted;

## Setup

1. Configurate cloud_storage

```elixir
# config.exs
config :cloud_storage, :repo, MyApp.Repo
config :cloud_storage, :default_asset_host, "https://cdn.com"
config :cloud_storage, :default_bucket, "mybucket"
config :cloud_storage, :default_storage_dir, "uploads/direct"
```

2. Generate migration

```bash
mix cloud_storage.install
mix ecto.migrate
```

3. Create an uploader

```elixir
# my_app/uploaders/default_uploader.ex
defmodule MyApp.Uploaders.DefaultUploader
  use CloudStorage.Uploader
end
```

4. Add routes

```elixir
# my_app_web/router.ex
defmodule MyAppWeb.Router do
  #...
  import CloudStorage.Router

  scope "/api" do
    cloud_storage_routes("/uploads", MyApp.Uploaders.DefaultUploader.Controller)
  end

  #...
end
```

5. Generate field

```bash
mix cloud_storage.gen.upload users avatar
```

```elixir
# my_app/users/user.ex
defmodule CloudStorage.User do
  use Ecto.Schema

  schema "users" do
    #...
    field :avatar, MyApp.Uploaders.DefaultUploader.Type

    timestamps()
  end
end
```

```bash
mix ecto.migrate
```
