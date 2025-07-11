defmodule DndTrackerWeb.ReferenceController do
  use DndTrackerWeb, :controller
  alias DndTracker.Adventures

  def index(conn, %{"adventure_id" => adventure_id}) do
    references = Adventures.get_references_for_adventure(adventure_id)
    json(conn, %{data: references})
  end
end
