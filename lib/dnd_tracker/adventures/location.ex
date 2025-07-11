defmodule DndTracker.Adventures.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :name, :string
    field :description, :map  # JSONB for rich text
    field :notes, :map        # JSONB for rich text
    field :reference_key, :string

    belongs_to :adventure, DndTracker.Adventures.Adventure
    has_many :points_of_interest, DndTracker.Adventures.PointOfInterest
    many_to_many :npcs, DndTracker.Adventures.Npc, join_through: "location_npcs"

    timestamps()
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :description, :notes, :reference_key, :adventure_id])
    |> validate_required([:name, :adventure_id])
    |> unique_constraint(:reference_key)
    |> foreign_key_constraint(:adventure_id)
  end
end