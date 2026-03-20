import type { Metadata } from "next"
import { Geist, Geist_Mono } from "next/font/google"
import Navbar from "@/components/Navbar"
import "./globals.css"
import { SearchProvider } from "@/components/SearchContext"
import Footer from "@/components/Footer"

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
})

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
})

export const metadata: Metadata = {
  title: "Game Store Catalog",
  description: "Browse and discover games",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased bg-gray-50 text-gray-800`}
      >
        <SearchProvider>
          <Navbar />

          {/* 🔥 MAIN CONTENT WRAPPER */}
          <main className="min-h-screen">
            {children}
          </main>

          <Footer />
        </SearchProvider>
      </body>
    </html>
  )
}