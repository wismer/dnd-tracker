defmodule DndTracker.Repo.Migrations.CreateAdventures do
  use Ecto.Migration

  def change do
    create table(:adventures) do
      add :name, :string, null: false
      add :description, :text
      add :type, :string, null: false
      add :status, :string, default: "planning"

      timestamps()
    end

    create constraint(:adventures, :type_must_be_valid, 
           check: "type IN ('campaign', 'one-shot')")
    create constraint(:adventures, :status_must_be_valid, 
           check: "status IN ('planning', 'active', 'completed', 'on-hold')")
    
    create index(:adventures, [:type])
    create index(:adventures, [:status])
  end
end