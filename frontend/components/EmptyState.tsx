"use client"
import { MdErrorOutline } from "react-icons/md"
type Props = {
  onClear: () => void
}
export default function EmptyState({ onClear }: Props) {
  return (
    <div className="flex flex-col items-center justify-center text-center py-20">
      <div className="relative flex items-center justify-center mb-6">
        <div className="absolute w-24 h-24 bg-red-500/20 rounded-full blur-2xl animate-pulse" />
        <div className="absolute w-16 h-16 bg-red-500/10 rounded-full" />
        <div className="relative w-14 h-14 flex items-center justify-center rounded-full border border-red-300 bg-white/80 backdrop-blur-md shadow-lg">
          <MdErrorOutline className="text-red-500 text-3xl" />
        </div>
      </div>
      <h2 className="text-2xl font-bold text-gray-800 mb-2">
        Game not Found
      </h2>
      <p className="text-gray-500 max-w-md mb-6">
        This game is not available at the moment or doesn’t exist.
        Please try again later!
      </p>
      <button
        onClick={onClear}
        className="bg-red-500 hover:bg-red-600 text-white px-6 py-3 rounded-xl transition duration-200 shadow-md hover:shadow-lg active:scale-95">
        Clear Filters
      </button>
    </div>
  )
}