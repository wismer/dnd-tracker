defmodule DndTrackerWeb.AdventureController do
  use DndTrackerWeb, :controller
  alias DndTracker.Adventures

  def index(conn, _params) do
    adventures = Adventures.list_adventures()
    json(conn, %{data: adventures})
  end

  def show(conn, %{"id" => id}) do
    adventure = Adventures.get_adventure!(id)
    json(conn, %{data: adventure})
  end

  def create(conn, %{"adventure" => adventure_params}) do
    case Adventures.create_adventure(adventure_params) do
      {:ok, adventure} ->
        conn
        |> put_status(:created)
        |> json(%{data: adventure})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "adventure" => adventure_params}) do
    adventure = Adventures.get_adventure!(id)

    case Adventures.update_adventure(adventure, adventure_params) do
      {:ok, adventure} ->
        json(conn, %{data: adventure})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    adventure = Adventures.get_adventure!(id)
    {:ok, _adventure} = Adventures.delete_adventure(adventure)
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