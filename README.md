# Sendup

Direct upload backend.

**TODO:**

- [ ] Upload schema
- [ ] Upload controller
- [ ] Upload field type
- [ ] Set up orphan tracking
- [ ] Set up clean orphan uploads

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sendup` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sendup, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/sendup>.

## How it works?

Sendup is a direct upload backend and it's compatible with multiple storage.
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

**How Sendup handle them?**

Uploads are tracked using Postgresql trigger function. Each time there is a change on an upload field (ex: avatar), sendup will take care of referencing/dereferencing the corresponding upload.
Orphan uploads not updated in the last month are automatically deleted;

## Setup

1. Configurate sendup

```elixir
# config.exs
config :sendup, :repo, MyApp.Repo
config :sendup, :default_asset_host, "https://cdn.com"
config :sendup, :default_bucket, "mybucket"
config :sendup, :default_storage_dir, "uploads/direct"
```

2. Generate migration

```bash
mix sendup.install
mix ecto.migrate
```

3. Create an uploader

```elixir
# my_app/uploaders/default_uploader.ex
defmodule MyApp.Uploaders.DefaultUploader
  use Sendup.Uploader
end
```

4. Add routes

```elixir
# my_app_web/router.ex
defmodule MyAppWeb.Router do
  #...
  import Sendup.Router

  scope "/api" do
    sendup_routes("/uploads", MyApp.Uploaders.DefaultUploader.Controller)
  end

  #...
end
```

5. Generate field

```bash
mix sendup.gen.upload users avatar
```

```elixir
# my_app/users/user.ex
defmodule Sendup.User do
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
