defmodule DndTracker.Repo.Migrations.AddReferenceKeyConstraints do
  use Ecto.Migration

  def change do
    # Add constraints to ensure reference_key format is valid
    # Reference keys should be lowercase, alphanumeric with hyphens
    create constraint(:locations, :reference_key_format, 
           check: "reference_key ~ '^[a-z0-9-]+$'")
    
    create constraint(:npcs, :reference_key_format, 
           check: "reference_key ~ '^[a-z0-9-]+$'")
    
    create constraint(:points_of_interest, :reference_key_format, 
           check: "reference_key ~ '^[a-z0-9-]+$'")

    # Add length constraints (reasonable limits)
    create constraint(:locations, :reference_key_length, 
           check: "char_length(reference_key) <= 100")
    
    create constraint(:npcs, :reference_key_length, 
           check: "char_length(reference_key) <= 100")
    
    create constraint(:points_of_interest, :reference_key_length, 
           check: "char_length(reference_key) <= 100")
  end
end