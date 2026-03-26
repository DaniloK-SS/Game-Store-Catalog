'use client'

import { useEffect } from 'react'
import { useRouter, usePathname } from 'next/navigation'

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter()
  const pathname = usePathname()

  useEffect(() => {
    const token = localStorage.getItem('token')

    if (!token && !pathname.startsWith('/admin/login')) {
      router.replace('/admin/login')
    }

  }, [pathname, router])

  return (
    <div className="min-h-screen bg-gray-100">
      {children}
    </div>
  )
}