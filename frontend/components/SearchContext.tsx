"use client"
import { createContext, useContext, useState } from "react"
type SearchContextType = {
  search: string
  setSearch: (value: string) => void
}
const SearchContext = createContext<SearchContextType | undefined>(undefined)
export function SearchProvider({ children }: { children: React.ReactNode }) {
  const [search, setSearch] = useState("")
  return (
    <SearchContext.Provider value={{ search, setSearch }}>
      {children}
    </SearchContext.Provider>
  )
}
export function useSearch() {
  const context = useContext(SearchContext)
  if (!context) throw new Error("useSearch must be used inside SearchProvider")
  return context
}
//morao bih navbaru da 5 puta dodavam prop search={search} setSearch={setSearch}