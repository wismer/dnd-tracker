# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DndTracker.Repo.insert!(%DndTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias DndTracker.Repo
alias DndTracker.Adventures.{Adventure, Location, Npc, PointOfInterest}

# Create a sample adventure
{:ok, adventure} = %Adventure{
  name: "The Haunted Tavern",
  description: "A mysterious one-shot adventure in a spooky tavern",
  type: "one-shot",
  status: "planning"
} |> Repo.insert()

# Create a sample location
{:ok, location} = %Location{
  name: "The Prancing Pony",
  description: %{
    "type" => "doc",
    "content" => [
      %{
        "type" => "paragraph",
        "content" => [
          %{"type" => "text", "text" => "A dimly lit tavern with creaky floorboards. The bar is tended by "},
          %{"type" => "reference", "attrs" => %{"key" => "barkeep-tom", "type" => "npc"}},
          %{"type" => "text", "text" => "."}
        ]
      }
    ]
  },
  reference_key: "prancing-pony",
  adventure_id: adventure.id
} |> Repo.insert()

# Create a sample NPC
{:ok, npc} = %Npc{
  name: "Tom the Barkeep",
  description: %{
    "type" => "doc",
    "content" => [
      %{
        "type" => "paragraph",
        "content" => [
          %{"type" => "text", "text" => "A gruff middle-aged man with suspicious eyes."}
        ]
      }
    ]
  },
  stats: %{
    "ac" => 12,
    "hp" => 15,
    "str" => 13,
    "dex" => 10,
    "con" => 12,
    "int" => 11,
    "wis" => 13,
    "cha" => 8
  },
  abilities: ["Intimidation", "Insight"],
  reference_key: "barkeep-tom",
  adventure_id: adventure.id
} |> Repo.insert()

# Create a sample point of interest
{:ok, _poi} = %PointOfInterest{
  name: "Mysterious Stain",
  description: %{
    "type" => "doc",
    "content" => [
      %{
        "type" => "paragraph",
        "content" => [
          %{"type" => "text", "text" => "A dark stain on the floor that looks suspiciously like blood."}
        ]
      }
    ]
  },
  skill_checks: %{
    "investigation" => %{
      "dc" => 15,
      "success" => "It's definitely blood, and it's recent.",
      "failure" => "Hard to tell what it is in this dim light."
    }
  },
  type: "clue",
  reference_key: "mysterious-stain",
  location_id: location.id
} |> Repo.insert()

# Associate the NPC with the location
Repo.insert!(%{location_id: location.id, npc_id: npc.id}, into: "location_npcs")

IO.puts "Sample data created successfully!"