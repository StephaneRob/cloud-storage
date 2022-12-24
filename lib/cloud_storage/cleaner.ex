defmodule CloudStorage.Cleaner do
  alias CloudStorage.Uploads
  use GenServer

  @interval :timer.hours(12)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    Process.send_after(self(), :clean, :timer.seconds(10))
    {:ok, opts}
  end

  @impl GenServer
  def handle_info(:clean, state) do
    clean()
    {:noreply, state}
  end

  defp clean do
    last_deleted = Uploads.get_last_deleted_batch()
    maybe_clean(last_deleted)
    Process.send_after(self(), :clean, @interval)
  end

  defp maybe_clean(nil), do: do_clean()

  defp maybe_clean(last_deleted) do
    next_batch_at = DateTime.add(last_deleted.inserted, 12, :hour)
    diff = DateTime.diff(next_batch_at, DateTime.utc_now())

    if diff > 0 do
      Process.send_after(self(), :clean, diff + 10)
    else
      do_clean()
    end
  end

  defp do_clean() do
    to_delete = Uploads.to_delete(100)

    if Enum.any?(to_delete) do
      {:ok, delete_log} = Uploads.create_delete_log()

      to_delete
      |> Enum.each(fn upload ->
        Uploads.delete_upload(upload, delete_log)
      end)
    end
  end
end
