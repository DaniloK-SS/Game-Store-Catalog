'use client'

import { useEffect } from 'react'
import { useRouter, usePathname } from 'next/navigation'

export default function AdminLayout({ children }: { children: React.ReactNode }) { //provjera za usera da li je logovan 
  const router = useRouter()
  const pathname = usePathname()

  useEffect(() => {
    const isAdmin = localStorage.getItem('isAdmin')
    if (!isAdmin && pathname !== '/admin/login') {
      router.replace('/admin/login')
    }
  }, [pathname, router])

  return <>{children}</>
}