export async function getGames(params?: {
  search?: string
  platform?: string
  genre?: string
  inStock?: boolean
  sort?: string
}) {
  const query = new URLSearchParams()

  if (params?.search) query.append("search", params.search)
  if (params?.platform) query.append("platform", params.platform)
  if (params?.genre) query.append("genre", params.genre)
  if (params?.inStock) query.append("inStock", "true")
  if (params?.sort) query.append("sort", params.sort)

  const res = await fetch(
    `https://game-store-catalog.onrender.com/api/games?${query.toString()}`, 
  )

  return res.json()
}