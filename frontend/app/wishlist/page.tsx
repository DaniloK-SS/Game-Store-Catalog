"use client";
import { useEffect, useState } from "react";
import GameCard from "@/components/GameCard";
import EmptyWishlist from "@/components/EmptyWishList";
import { getGames } from "@/lib/GetGames";

const getWishlist = (): number[] => {
  const stringList = localStorage.getItem("wishlist");
  return (
    stringList
      ?.split(",")
      .map((x) => Number(x.trim()))
      .filter((num) => !isNaN(num)) ?? []
  );
};

const isInWishlist = (wishlist: number[], gameId: number) => {
  return wishlist.some((id) => id === gameId);
};

export default function WishlistPage() {
  const [wishlist, setWishlist] = useState<number[]>([]);
  const [games, setGames] = useState<any[]>([]);
  const [loaded, setLoaded] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      const savedWishlist = getWishlist();
      setWishlist(savedWishlist);

      const data = await getGames();

      const parsedGames = Array.isArray(data)
        ? data
        : data?.data || data?.games || [];

      const normalizedGames = parsedGames.map((g: any) => ({
        ...g,
        id: Number(g.id),
        price: Number(g.price),
      }));

      setGames(normalizedGames);
      setLoaded(true);
      setLoading(false);
    }

    fetchData();
  }, []);

  const handleRemoveFromWishlist = (gameId: number) => {
    const newWishlist = wishlist.filter((id) => id !== gameId);
    setWishlist(newWishlist);
    localStorage.setItem("wishlist", newWishlist.join(","));
  };

  const wishlistGames = games.filter((game) => wishlist.includes(game.id));

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <div
        className={`mb-8 transition-all duration-500 ${
          loaded ? "opacity-100 translate-y-0" : "opacity-0 translate-y-4"
        }`}
      >
        <h1 className="text-3xl font-bold text-gray-800">Your Wishlist</h1>
        <p className="text-sm text-gray-500 mt-1">
          {wishlistGames.length} saved game{wishlistGames.length !== 1 && "s"}
        </p>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {[...Array()].map((_, i) => (
            <div
              key={i}
              className="h-72 bg-gray-100 rounded-xl animate-pulse"
            />
          ))}
        </div>
      ) : wishlistGames.length === 0 ? (
        <div className="animate-fadeIn">
          <EmptyWishlist />
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {wishlistGames.map((game, index) => (
            <div
              key={game.id}
              className={`transition-all duration-500 ${
                loaded ? "opacity-100 translate-y-0" : "opacity-0 translate-y-6"
              } hover:-translate-y-2 hover:shadow-xl`}
              style={{
                transitionDelay: `${index * 80}ms`,
              }}
            >
              <GameCard
                game={game}
                onAddToWishlist={() => {}}
                onRemoveFromWishlist={handleRemoveFromWishlist}
                isInWishlist={(gameId) => isInWishlist(wishlist, gameId)}
              />
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
