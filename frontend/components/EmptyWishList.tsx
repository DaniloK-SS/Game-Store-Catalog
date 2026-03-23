"use client"
export default function EmptyWishlist() {
  return (
    <div className="flex flex-col items-center justify-center text-center py-24">
      <h2 className="text-2xl font-bold text-gray-800 mb-2">
        Your wishlist is empty
      </h2>

      <p className="text-gray-500 max-w-md mb-6">
        Looks like you haven't added any games yet.
        Start exploring and add your favorites!
      </p>

      <a
        href="/games"
        className="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-xl transition"
      >
        Browse Games
      </a>

    </div>
  )
}