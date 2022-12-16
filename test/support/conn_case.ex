defmodule Sendup.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      alias Sendup.Dummy.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint Sendup.Dummy.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sendup.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Sendup.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
