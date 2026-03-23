export async function getGames() {
  try {
    const res = await fetch("https://game-store-catalog.onrender.com/api/games", {
      cache: "no-store",
    })

    if (!res.ok) throw new Error("Failed to fetch")

    const data = await res.json()

    return data.data // uzima api []
  } catch (error) {
    console.error("API error:", error)
    return []
  }
}