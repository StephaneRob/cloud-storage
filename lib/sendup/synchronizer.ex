defmodule Sendup.Synchronizer do
  alias Sendup.Uploads
  use GenServer

  @interval :timer.seconds(30)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    Process.send_after(self(), :run, @interval)
    {:ok, opts}
  end

  @impl GenServer
  def handle_info(:run, state) do
    Process.send_after(self(), :run, @interval)
    logs = Uploads.list_logs(100)

    logs
    |> Enum.each(fn log ->
      if log.old_key, do: flag_upload(log.old_key, true)
      if log.new_key, do: flag_upload(log.new_key, false)
      Uploads.delete_log(log)
    end)

    {:noreply, state}
  end

  defp flag_upload(key, orphan) do
    upload = Uploads.get_upload_by_key(key)
    if upload, do: Uploads.mark_as_orphan(upload, orphan)
  end
end
