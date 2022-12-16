defmodule Sendup.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Sendup.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sendup.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Sendup.Repo, {:shared, self()})
    end

    :ok
  end
end
