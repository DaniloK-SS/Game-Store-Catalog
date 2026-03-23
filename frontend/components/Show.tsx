"use client"
import { useState } from "react"
type Props = {
  sort: string
  setSort: (value: string) => void
}
export default function Show({ sort, setSort }: Props) {
  const [open, setOpen] = useState(false)
  const handleSelect = (value: string) => {
    setSort(value)
    setOpen(false)
  }
  const label =
    sort === "new"
      ? "New Release"
      : sort === "old"
      ? "Old → New"
      : "New → Old"

  return (
    <div className="flex items-center justify-center gap-2 mt-4 relative">
      <span className="text-gray-600 text-lg">Show:</span>
      <button
        onClick={() => setOpen(!open)}
        className="flex items-center gap-2 text-indigo-600 font-medium text-lg hover:underline">
        {label}
        <span className={`transition-transform ${open ? "rotate-180" : ""}`}>
          ▼
        </span>
      </button>
      {open && (
        <div className="absolute top-10 bg-white shadow-lg rounded-xl border p-2 w-40 text-sm z-50">
          <button
            onClick={() => handleSelect("new")}
            className="block w-full text-left px-3 py-2 hover:bg-gray-100 rounded-lg">
            New → Old
          </button>
          <button
            onClick={() => handleSelect("old")}
            className="block w-full text-left px-3 py-2 hover:bg-gray-100 rounded-lg">
            Old → New
          </button>
        </div>
      )}
    </div>
  )
}