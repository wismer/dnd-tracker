defmodule DndTrackerWeb.HomeController do
  use DndTrackerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
