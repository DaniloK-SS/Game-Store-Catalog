"use client"
import { useState } from "react"
import { useRouter } from "next/navigation"
import { FaInstagram } from "react-icons/fa6"
import { CiFacebook } from "react-icons/ci"
import { FaXTwitter } from "react-icons/fa6"
import { PiYoutubeLogo } from "react-icons/pi"
import { PiUserCircleCheckFill } from "react-icons/pi"

const sections = [
  "GAMES",
  "MARKETPLACE",
  "PROMOTIONS",
  "ONLINE SERVICES",
  "COMPANY",
  "RESOURCES",
  "ADMIN",
]

export default function Footer() {
  const [open, setOpen] = useState<string | null>(null)
  const router = useRouter()

  const toggle = (section: string) => {
    setOpen(open === section ? null : section)
  }

  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    })
  }

  return (
    <footer className="w-full bg-gray-50 mt-16 py-10 px-4 text-gray-600 border-t">
      <div className="max-w-5xl mx-auto">

        <h3 className="text-center text-sm font-semibold tracking-widest text-gray-500 mb-4">
          GAME STORE🎮
        </h3>

        <div className="flex justify-center gap-6 text-xl mb-6 text-gray-500">
          <FaInstagram className="cursor-pointer hover:text-indigo-600 hover:scale-110 transition"/>
          <CiFacebook className="cursor-pointer hover:text-indigo-600 hover:scale-110 transition"/>
          <FaXTwitter className="cursor-pointer hover:text-indigo-600 hover:scale-110 transition"/>
          <PiYoutubeLogo className="cursor-pointer hover:text-indigo-600 hover:scale-110 transition"/>
        </div>

        <div className="space-y-2">
          {sections.map((section) => (
            <div key={section} className="border-b border-gray-200 py-2">

              <button
                onClick={() => toggle(section)}
                className="w-full flex justify-between items-center text-sm font-semibold text-gray-700 hover:text-indigo-600 transition"
              >
                <div className="flex items-center gap-2">
                  {section === "ADMIN" && (
                    <PiUserCircleCheckFill className="text-base text-indigo-600" />
                  )}
                  {section}
                </div>

                <span className={`text-lg transition-transform ${open === section ? "rotate-180 text-indigo-600" : ""}`}>
                  +
                </span>
              </button>

              <div className={`overflow-hidden transition-all duration-300 ${open === section ? "max-h-40 mt-2" : "max-h-0"}`}>

                {section !== "ADMIN" && (
                  <p className="text-xs text-gray-500">Coming soon...</p>
                )}

                {section === "ADMIN" && (
                  <div className="flex flex-col gap-2 mt-2">
                    <button
                      onClick={() => router.push("/admin/login")}
                      className="flex items-center gap-2 text-xs bg-indigo-600 text-white px-3 py-2 rounded-md 
                      hover:bg-indigo-700 hover:scale-105 active:scale-95 transition-all w-fit"
                    >
                      <PiUserCircleCheckFill className="text-base" />
                      Admin Panel
                    </button>

                    <p className="text-xs text-gray-400">
                      Secure access for administrators
                    </p>
                  </div>
                )}

              </div>
            </div>
          ))}
        </div>

        <p className="text-[11px] text-gray-400 mt-6 leading-relaxed text-center max-w-2xl mx-auto">
          © 2026, Game Shop, Inc. All rights reserved. Games, the Game Shop logo are trademarks or registered trademarks.
        </p>

        <div className="flex flex-wrap justify-center gap-3 text-xs text-gray-500 mt-4">
          <a href="#" className="hover:text-indigo-600 transition">About Us</a>
          <a href="#" className="hover:text-indigo-600 transition">Privacy Policy</a>
          <a href="#" className="hover:text-indigo-600 transition">Help</a>
          <a href="#" className="hover:text-indigo-600 transition">Conditions of Use</a>
          <a href="#" className="hover:text-indigo-600 transition">Publisher Index</a>
        </div>

        <div className="flex justify-center mt-6">
          <button
            onClick={scrollToTop}
            className="bg-indigo-600 text-white text-sm px-5 py-2 rounded-lg 
            hover:bg-indigo-700 hover:scale-105 active:scale-95 transition-all shadow-md"
          >
            Back to top ⬆
          </button>
        </div>

      </div>
    </footer>
  )
}