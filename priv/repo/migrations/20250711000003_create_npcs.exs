defmodule DndTracker.Repo.Migrations.CreateNpcs do
  use Ecto.Migration

  def change do
    create table(:npcs) do
      add :name, :string, null: false
      add :description, :jsonb
      add :stats, :jsonb
      add :abilities, {:array, :string}, default: []
      add :notes, :jsonb
      add :reference_key, :string
      add :adventure_id, references(:adventures, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:npcs, [:adventure_id])
    create unique_index(:npcs, [:reference_key])
    
    # Add GIN indexes for JSONB fields and array field
    create index(:npcs, [:description], using: :gin)
    create index(:npcs, [:stats], using: :gin)
    create index(:npcs, [:notes], using: :gin)
    create index(:npcs, [:abilities], using: :gin)
  end
end