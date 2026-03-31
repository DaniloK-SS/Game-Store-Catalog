"use client";

import { useEffect, useState } from "react";
import GameGrid from "@/components/GameGrid";
import FilterPanel from "@/components/FilterPanel";
import { useSearch } from "@/components/SearchContext";
import EmptyState from "@/components/EmptyState";
import { getGames } from "@/lib/GetGames";

export default function GamesPage() {
  const { search, setSearch } = useSearch();

  const [games, setGames] = useState<any[]>([]);
  const [platform, setPlatform] = useState("");
  const [genre, setGenre] = useState("");
  const [inStock, setInStock] = useState(false);
  const [sort, setSort] = useState("");
  const [wishlist, setWishlist] = useState<number[]>([]);

  useEffect(() => {
    async function fetchData() {
      const data = await getGames({
        search,
        platform,
        genre,
        inStock,
        sort,
      });

      const parsedGames = Array.isArray(data) ? data : data?.data || [];

      const normalizedGames = parsedGames.map((g: any) => ({
        ...g,
        id: Number(g.id),
        price: Number(g.price),
      }));

      setGames(normalizedGames);
    }

    fetchData();
  }, [search, platform, genre, inStock, sort]);

  useEffect(() => {
    const stored = localStorage.getItem("wishlist");
    if (stored) {
      setWishlist(stored.split(",").map(Number));
    }
  }, []);

  const isInWishlist = (id: number) => {
    return wishlist.includes(id);
  };

  const handleAddToWishlist = (id: number) => {
    if (wishlist.includes(id)) return;
    const updated = [...wishlist, id];
    setWishlist(updated);
    localStorage.setItem("wishlist", updated.join(","));
  };

  const handleRemoveFromWishlist = (id: number) => {
    const updated = wishlist.filter((w) => w !== id);
    setWishlist(updated);
    localStorage.setItem("wishlist", updated.join(","));
  };

  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6 text-gray-800">Game Store</h1>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="md:col-span-1">
          <FilterPanel
            platform={platform}
            setPlatform={setPlatform}
            genre={genre}
            setGenre={setGenre}
            inStock={inStock}
            setInStock={setInStock}
            sort={sort}
            setSort={setSort}
          />
        </div>

        <div className="md:col-span-3">
          {games.length === 0 ? (
            <EmptyState
              onClear={() => {
                setPlatform("");
                setGenre("");
                setInStock(false);
                setSort("");
                setSearch("");
              }}
            />
          ) : (
            <GameGrid
              games={games}
              isInWishlist={isInWishlist}
              onAddToWishlist={handleAddToWishlist}
              onRemoveFromWishlist={handleRemoveFromWishlist}
            />
          )}
        </div>
      </div>
    </div>
  );
}
