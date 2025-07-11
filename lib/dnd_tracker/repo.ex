defmodule DndTracker.Repo do
  use Ecto.Repo,
    otp_app: :dnd_tracker,
    adapter: Ecto.Adapters.Postgres
end
