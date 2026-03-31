import Link from "next/link";

export default function GameNotFound() {
  return (
    <div className="p-10 text-center">
      <h2 className="text-2xl font-bold mb-4">Game not found</h2>
      <Link href="/" className="text-indigo-600 underline">
        Back to Home
      </Link>
    </div>
  );
}
