defmodule DndTracker.Adventures do
  import Ecto.Query, warn: false
  alias DndTracker.Repo
  alias DndTracker.Adventures.{Adventure, Location, Npc, PointOfInterest}

  # Adventures
  def list_adventures do
    Repo.all(Adventure)
  end

  def get_adventure!(id) do
    Repo.get!(Adventure, id)
    |> Repo.preload([:locations, :npcs])
  end

  def create_adventure(attrs \\ %{}) do
    %Adventure{}
    |> Adventure.changeset(attrs)
    |> Repo.insert()
  end

  def update_adventure(%Adventure{} = adventure, attrs) do
    adventure
    |> Adventure.changeset(attrs)
    |> Repo.update()
  end

  def delete_adventure(%Adventure{} = adventure) do
    Repo.delete(adventure)
  end

  # Locations
  def list_locations_for_adventure(adventure_id) do
    from(l in Location, where: l.adventure_id == ^adventure_id)
    |> Repo.all()
    |> Repo.preload([:points_of_interest, :npcs])
  end

  def get_location!(id) do
    Repo.get!(Location, id)
    |> Repo.preload([:points_of_interest, :npcs])
  end

  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  # NPCs
  def list_npcs_for_adventure(adventure_id) do
    from(n in Npc, where: n.adventure_id == ^adventure_id)
    |> Repo.all()
    |> Repo.preload([:locations])
  end

  def create_npc(attrs \\ %{}) do
    %Npc{}
    |> Npc.changeset(attrs)
    |> Repo.insert()
  end

  # Points of Interest
  def list_points_of_interest_for_location(location_id) do
    from(p in PointOfInterest, where: p.location_id == ^location_id)
    |> Repo.all()
  end

  def create_point_of_interest(attrs \\ %{}) do
    %PointOfInterest{}
    |> PointOfInterest.changeset(attrs)
    |> Repo.insert()
  end

  # Reference lookup for rich text editor
  def get_references_for_adventure(adventure_id) do
    locations = from(l in Location, 
                    where: l.adventure_id == ^adventure_id and not is_nil(l.reference_key),
                    select: %{id: l.id, name: l.name, reference_key: l.reference_key, type: "location"})
    
    npcs = from(n in Npc,
               where: n.adventure_id == ^adventure_id and not is_nil(n.reference_key),
               select: %{id: n.id, name: n.name, reference_key: n.reference_key, type: "npc"})
    
    pois = from(p in PointOfInterest,
               join: l in Location, on: p.location_id == l.id,
               where: l.adventure_id == ^adventure_id and not is_nil(p.reference_key),
               select: %{id: p.id, name: p.name, reference_key: p.reference_key, type: "poi"})
    
    (Repo.all(locations) ++ Repo.all(npcs) ++ Repo.all(pois))
    |> Enum.sort_by(& &1.name)
  end
end