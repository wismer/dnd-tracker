defmodule DndTracker.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string, null: false
      add :description, :jsonb
      add :notes, :jsonb
      add :reference_key, :string
      add :adventure_id, references(:adventures, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:locations, [:adventure_id])
    create unique_index(:locations, [:reference_key])
    
    # Add GIN index for JSONB fields for better search performance
    create index(:locations, [:description], using: :gin)
    create index(:locations, [:notes], using: :gin)
  end
end