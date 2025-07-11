defmodule DndTrackerWeb.Router do
  use DndTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  scope "/api/v1", DndTrackerWeb do
    pipe_through :api

    # Adventures
    resources "/adventures", AdventureController, except: [:new, :edit] do
      # Nested routes
      resources "/locations", LocationController, except: [:new, :edit]
      resources "/npcs", NpcController, except: [:new, :edit]
    end

    # Locations can have points of interest
    resources "/locations", LocationController, only: [] do
      resources "/points_of_interest", PointOfInterestController, except: [:new, :edit]
    end

    # NPC-Location associations
    post "/locations/:location_id/npcs/:npc_id", LocationNpcController, :create
    delete "/locations/:location_id/npcs/:npc_id", LocationNpcController, :delete

    # Reference lookup (for rich text editor)
    get "/adventures/:adventure_id/references", ReferenceController, :index
  end
end