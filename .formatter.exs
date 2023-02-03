[
  import_deps: [:ecto_sql, :ecto, :phoenix],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [cloud_storage_routes: 2, cloud_storage_routes: 3],
  export: [
    locals_without_parens: [cloud_storage_routes: 2, cloud_storage_routes: 3]
  ]
]
