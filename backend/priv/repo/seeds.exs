alias GameStore.Repo
alias GameStore.Games
alias GameStore.Games.Game

IO.puts("=== Starting Database Seed ===")

IO.puts("Cleaning up existing games...")
Repo.delete_all(Game)

games = [
  %{
    title: "Steel Horizon",
    genre: "Action",
    platform: "PC",
    price: Decimal.new("39.99"),
    release_year: 2024,
    publisher: "North Pixel",
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270962/k3rr3exnnzgiiry4yf9h.webp",
    description: "A fast-paced action game set in a futuristic city filled with advanced technology and dangerous enemies.",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270964/efcr6zrf253trrqitngh.jpg",
    description: "An epic fantasy RPG where players explore mysterious lands and battle powerful creatures.",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270965/sdcyhskqbtt4nyktgrkm.jpg",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270966/p4goxo75925yd5ezzbsr.jpg",
    description: "A cyberpunk adventure game where you uncover secrets hidden in a neon-lit city.",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270967/s231umfxahbfym7dhqjh.jpg",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270969/ljvnxz3flarmsa34unwq.png",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270971/lw4ysmlhmlatucprfxmi.jpg",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270973/rgvnpbo9vbkr7fjzb1cf.jpg",
    description: "Survive a terrifying zombie apocalypse and uncover the truth behind the outbreak.",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270974/itpl93jpcowlmhoog5c7.jpg",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774271393/xvjbw6tnircwqsjgsscv.jpg",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774270995/qes67t88lrm9s8mkbd1x.jpg",
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
    cover_image: "https://res.cloudinary.com/dnq35ub8e/image/upload/v1774271006/irqmrzq9vdi9o1og48ki.jpg",
    description: "Survive on a deserted island by crafting tools and building shelters.",
    in_stock: true,
    featured: false
  }
]

IO.puts("Inserting #{Enum.count(games)} games with Cloudinary images...")

Enum.each(games, fn attrs ->
  case Games.create_game(attrs) do
    {:ok, game} ->
      IO.puts("Created: #{game.title}")

    {:error, changeset} ->
      IO.inspect(changeset.errors, label: "Could not create game #{attrs.title}")
      raise "Seed failed"
  end
end)

# Re-deploys may attempt to create the same admin users again.
# If a user already exists, create_user/1 will return an error
# and we log it as skipped.
admin_accounts = [
  {
    System.get_env("STEFAN_EMAIL"),
    System.get_env("STEFAN_PASSWORD")
  },
  {
    System.get_env("DANILO_EMAIL"),
    System.get_env("DANILO_PASSWORD")
  }
]

for {email, password} <- admin_accounts do
  if email && password do
    case GameStore.Accounts.create_user(%{
      email: email,
      password: password,
      role: "admin"
    }) do
      {:ok, user} -> IO.puts("Created admin: #{user.email}")
      {:error, changeset} -> IO.puts("Skipped #{email}: #{inspect(changeset.errors)}")
    end
  end
end

IO.puts("=== Seed Finished Successfully ===")
