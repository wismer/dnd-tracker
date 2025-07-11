defmodule DndTracker.Adventures.Adventure do
  use Ecto.Schema
  import Ecto.Changeset

  schema "adventures" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :status, :string, default: "planning"

    has_many :locations, DndTracker.Adventures.Location
    has_many :npcs, DndTracker.Adventures.Npc

    timestamps()
  end

  def changeset(adventure, attrs) do
    adventure
    |> cast(attrs, [:name, :description, :type, :status])
    |> validate_required([:name, :type])
    |> validate_inclusion(:type, ["campaign", "one-shot"])
    |> validate_inclusion(:status, ["planning", "active", "completed", "on-hold"])
  end
end