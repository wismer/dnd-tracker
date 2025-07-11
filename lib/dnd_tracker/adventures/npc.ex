defmodule DndTracker.Adventures.Npc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "npcs" do
    field :name, :string
    field :description, :map     # JSONB for rich text
    field :stats, :map          # JSONB for flexible stats
    field :abilities, {:array, :string}
    field :notes, :map          # JSONB for rich text
    field :reference_key, :string

    belongs_to :adventure, DndTracker.Adventures.Adventure
    many_to_many :locations, DndTracker.Adventures.Location, join_through: "location_npcs"

    timestamps()
  end

  def changeset(npc, attrs) do
    npc
    |> cast(attrs, [:name, :description, :stats, :abilities, :notes, :reference_key, :adventure_id])
    |> validate_required([:name, :adventure_id])
    |> unique_constraint(:reference_key)
    |> foreign_key_constraint(:adventure_id)
  end
end
