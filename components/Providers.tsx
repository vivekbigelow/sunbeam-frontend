"use client";
import { AuthProvider } from "@/app/hooks/useAuth";

export function Providers({ children }: { children: React.ReactNode }) {
  return <AuthProvider>{children}</AuthProvider>;
}
