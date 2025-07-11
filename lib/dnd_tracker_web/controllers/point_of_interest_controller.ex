defmodule DndTrackerWeb.PointOfInterestController do
  use DndTrackerWeb, :controller
  alias DndTracker.Adventures

  def index(conn, %{"location_id" => location_id}) do
    points_of_interest = Adventures.list_points_of_interest_for_location(location_id)
    json(conn, %{data: points_of_interest})
  end

  def show(conn, %{"id" => id}) do
    point_of_interest = Adventures.get_point_of_interest!(id)
    json(conn, %{data: point_of_interest})
  end

  def create(conn, %{"location_id" => location_id, "point_of_interest" => poi_params}) do
    poi_params = Map.put(poi_params, "location_id", location_id)

    case Adventures.create_point_of_interest(poi_params) do
      {:ok, point_of_interest} ->
        conn
        |> put_status(:created)
        |> json(%{data: point_of_interest})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "point_of_interest" => poi_params}) do
    point_of_interest = Adventures.get_point_of_interest!(id)

    case Adventures.update_point_of_interest(point_of_interest, poi_params) do
      {:ok, point_of_interest} ->
        json(conn, %{data: point_of_interest})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    point_of_interest = Adventures.get_point_of_interest!(id)
    {:ok, _point_of_interest} = Adventures.delete_point_of_interest(point_of_interest)
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