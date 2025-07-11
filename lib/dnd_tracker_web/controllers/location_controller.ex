defmodule DndTrackerWeb.LocationController do
  use DndTrackerWeb, :controller
  alias DndTracker.Adventures

  def index(conn, %{"adventure_id" => adventure_id}) do
    locations = Adventures.list_locations_for_adventure(adventure_id)
    json(conn, %{data: locations})
  end

  def show(conn, %{"id" => id}) do
    location = Adventures.get_location!(id)
    json(conn, %{data: location})
  end

  def create(conn, %{"adventure_id" => adventure_id, "location" => location_params}) do
    location_params = Map.put(location_params, "adventure_id", adventure_id)

    case Adventures.create_location(location_params) do
      {:ok, location} ->
        conn
        |> put_status(:created)
        |> json(%{data: location})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Adventures.get_location!(id)

    case Adventures.update_location(location, location_params) do
      {:ok, location} ->
        json(conn, %{data: location})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Adventures.get_location!(id)
    {:ok, _location} = Adventures.delete_location(location)
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