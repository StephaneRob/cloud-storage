defmodule CloudStorage.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias CloudStorage.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CloudStorage.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CloudStorage.Repo, {:shared, self()})
    end

    :ok
  end
end
