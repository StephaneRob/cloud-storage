defmodule CloudStorage.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [CloudStorage.Synchronizer, CloudStorage.Cleaner]
    opts = [strategy: :one_for_one, name: CloudStorage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
