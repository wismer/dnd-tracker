defmodule DndTracker.Repo.Migrations.CreatePointsOfInterest do
  use Ecto.Migration

  def change do
    create table(:points_of_interest) do
      add :name, :string, null: false
      add :description, :jsonb
      add :skill_checks, :jsonb
      add :notes, :jsonb
      add :type, :string, default: "general"
      add :reference_key, :string
      add :location_id, references(:locations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:points_of_interest, [:location_id])
    create index(:points_of_interest, [:type])
    create unique_index(:points_of_interest, [:reference_key])
    
    # Add GIN indexes for JSONB fields
    create index(:points_of_interest, [:description], using: :gin)
    create index(:points_of_interest, [:skill_checks], using: :gin)
    create index(:points_of_interest, [:notes], using: :gin)
  end
end