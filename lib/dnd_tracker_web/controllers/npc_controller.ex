defmodule DndTrackerWeb.NpcController do
  use DndTrackerWeb, :controller
  alias DndTracker.Adventures

  def index(conn, %{"adventure_id" => adventure_id}) do
    npcs = Adventures.list_npcs_for_adventure(adventure_id)
    json(conn, %{data: npcs})
  end

  def show(conn, %{"id" => id}) do
    npc = Adventures.get_npc!(id)
    json(conn, %{data: npc})
  end

  def create(conn, %{"adventure_id" => adventure_id, "npc" => npc_params}) do
    npc_params = Map.put(npc_params, "adventure_id", adventure_id)

    case Adventures.create_npc(npc_params) do
      {:ok, npc} ->
        conn
        |> put_status(:created)
        |> json(%{data: npc})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "npc" => npc_params}) do
    npc = Adventures.get_npc!(id)

    case Adventures.update_npc(npc, npc_params) do
      {:ok, npc} ->
        json(conn, %{data: npc})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    npc = Adventures.get_npc!(id)
    {:ok, _npc} = Adventures.delete_npc(npc)
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
