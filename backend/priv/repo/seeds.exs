alias GameStore.Repo
alias GameStore.Games
alias GameStore.Games.Game

IO.puts("=== Starting Database Seed ===")

IO.puts("Cleaning up existing games...")
Repo.delete_all(Game)

# This list combines your new data with the structure required by your Elixir backend
games = [
  %{
    title: "Steel Horizon",
    genre: "Action",
    platform: "PC",
    price: Decimal.new("39.99"),
    release_year: 2024,
    publisher: "North Pixel",
    cover_image:
      "https://static.icy-veins.com/wp/wp-content/uploads/2025/11/horizon-steel-frontiers.webp",
    description:
      "A fast-paced action game set in a futuristic city filled with advanced technology and dangerous enemies.",
    in_stock: true,
    featured: true
  },
  %{
    title: "Shadow Kingdom",
    genre: "RPG",
    platform: "PlayStation",
    price: Decimal.new("59.99"),
    release_year: 2023,
    publisher: "DarkForge Studios",
    cover_image:
      "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/387450/header.jpg?t=1447377116",
    description:
      "An epic fantasy RPG where players explore mysterious lands and battle powerful creatures.",
    in_stock: true,
    featured: true
  },
  %{
    title: "Galaxy Racers",
    genre: "Racing",
    platform: "Xbox",
    price: Decimal.new("29.99"),
    release_year: 2022,
    publisher: "Speedline Games",
    cover_image:
      "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/4078430/3c44afd74567d593c23049525c1b0376ae80e287/capsule_616x353.jpg?t=1773076074",
    description: "Race across futuristic planets in this high-speed sci-fi racing experience.",
    in_stock: true,
    featured: false
  },
  %{
    title: "Cyber Quest",
    genre: "Adventure",
    platform: "PC",
    price: Decimal.new("49.99"),
    release_year: 2024,
    publisher: "Neon Studios",
    cover_image:
      "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/3197540/header.jpg?t=1736030080",
    description:
      "A cyberpunk adventure game where you uncover secrets hidden in a neon-lit city.",
    in_stock: true,
    featured: true
  },
  %{
    title: "Battle Arena X",
    genre: "Action",
    platform: "PlayStation",
    price: Decimal.new("44.99"),
    release_year: 2023,
    publisher: "ArenaWorks",
    cover_image:
      "https://c4.wallpaperflare.com/wallpaper/258/925/224/action-arena-arts-battle-wallpaper-preview.jpg",
    description: "Compete in intense multiplayer battles in a futuristic arena.",
    in_stock: false,
    featured: false
  },
  %{
    title: "Mystic Lands",
    genre: "RPG",
    platform: "PC",
    price: Decimal.new("54.99"),
    release_year: 2022,
    publisher: "Fantasy Labs",
    cover_image:
      "https://cf.geekdo-images.com/a8vBlOlMCf4p-nPIkOEh3g__opengraph/img/ozE9JTE5B6Dt0hhb6fIy1q8SiZ8=/0x0:3506x1841/fit-in/1200x630/filters:strip_icc()/pic9193406.png",
    description: "Explore magical kingdoms, complete quests, and discover hidden treasures.",
    in_stock: true,
    featured: false
  },
  %{
    title: "Street Drift",
    genre: "Racing",
    platform: "PC",
    price: Decimal.new("24.99"),
    release_year: 2021,
    publisher: "Urban Speed",
    cover_image: "https://wallpapercave.com/wp/wp9223939.jpg",
    description: "Master the art of drifting through challenging city tracks.",
    in_stock: true,
    featured: false
  },
  %{
    title: "Zombie Outbreak",
    genre: "Horror",
    platform: "Xbox",
    price: Decimal.new("34.99"),
    release_year: 2023,
    publisher: "Nightmare Studios",
    cover_image: "https://wallpaperaccess.com/full/7862874.jpg",
    description:
      "Survive a terrifying zombie apocalypse and uncover the truth behind the outbreak.",
    in_stock: false,
    featured: false
  },
  %{
    title: "Sky Legends",
    genre: "Adventure",
    platform: "PlayStation",
    price: Decimal.new("39.99"),
    release_year: 2022,
    publisher: "CloudNine Games",
    cover_image: "https://wallpaper.forfun.com/fetch/19/193ff5bbd4986e4c92781842a98dc5b6.jpeg",
    description: "Fly through magical skies and discover ancient floating islands.",
    in_stock: true,
    featured: false
  },
  %{
    title: "Warzone Elite",
    genre: "Shooter",
    platform: "PC",
    price: Decimal.new("59.99"),
    release_year: 2024,
    publisher: "IronCore Studios",
    cover_image: "https://images.alphacoders.com/113/1136137.jpg",
    description: "A tactical military shooter with intense multiplayer battles.",
    in_stock: false,
    featured: true
  },
  %{
    title: "Puzzle Mind",
    genre: "Puzzle",
    platform: "PC",
    price: Decimal.new("14.99"),
    release_year: 2021,
    publisher: "Brainy Games",
    cover_image:
      "https://img.freepik.com/premium-photo/picture-person-s-head-with-puzzle-pieces-shape-brain-generative-ai_97167-9425.jpg",
    description: "Challenge your brain with complex puzzles and mind-bending challenges.",
    in_stock: true,
    featured: false
  },
  %{
    title: "Island Survival",
    genre: "Survival",
    platform: "Xbox",
    price: Decimal.new("34.99"),
    release_year: 2023,
    publisher: "WildCraft Studios",
    cover_image:
      "https://images.wallpapersden.com/image/download/survival-island-evo-pro_a2lsbGmUmZqaraWkpJRqaGllrWhlZW0.jpg",
    description: "Survive on a deserted island by crafting tools and building shelters.",
    in_stock: true,
    featured: false
  }
]

IO.puts("Inserting #{Enum.count(games)} games with live image references...")

Enum.each(games, fn attrs ->
  case Games.create_game(attrs) do
    {:ok, game} ->
      IO.puts("Created: #{game.title}")

    {:error, changeset} ->
      IO.inspect(changeset.errors, label: "Could not create game #{attrs.title}")
      raise "Seed failed"
  end
end)

IO.puts("=== Seed Finished Successfully ===")
