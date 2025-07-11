defmodule DndTrackerWeb.LocationNpcController do
  use DndTrackerWeb, :controller
  alias DndTracker.Adventures

  def create(conn, %{"location_id" => location_id, "npc_id" => npc_id}) do
    case Adventures.add_npc_to_location(location_id, npc_id) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> json(%{message: "NPC added to location"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def delete(conn, %{"location_id" => location_id, "npc_id" => npc_id}) do
    {:ok, _} = Adventures.remove_npc_from_location(location_id, npc_id)
    send_resp(conn, :no_content, "")
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end