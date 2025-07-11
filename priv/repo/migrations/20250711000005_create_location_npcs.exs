defmodule DndTracker.Repo.Migrations.CreateLocationNpcs do
  use Ecto.Migration

  def change do
    create table(:location_npcs, primary_key: false) do
      add :location_id, references(:locations, on_delete: :delete_all), null: false
      add :npc_id, references(:npcs, on_delete: :delete_all), null: false
      add :notes, :text
    end

    create index(:location_npcs, [:location_id])
    create index(:location_npcs, [:npc_id])
    create unique_index(:location_npcs, [:location_id, :npc_id])
  end
end