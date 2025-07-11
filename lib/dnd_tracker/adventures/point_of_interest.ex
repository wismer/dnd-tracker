defmodule DndTracker.Adventures.PointOfInterest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points_of_interest" do
    field :name, :string
    field :description, :map     # JSONB for rich text
    field :skill_checks, :map    # JSONB for skill check data
    field :notes, :map          # JSONB for rich text
    field :type, :string, default: "general"
    field :reference_key, :string

    belongs_to :location, DndTracker.Adventures.Location

    timestamps()
  end

  def changeset(point_of_interest, attrs) do
    point_of_interest
    |> cast(attrs, [:name, :description, :skill_checks, :notes, :type, :reference_key, :location_id])
    |> validate_required([:name, :location_id])
    |> unique_constraint(:reference_key)
    |> foreign_key_constraint(:location_id)
  end
end