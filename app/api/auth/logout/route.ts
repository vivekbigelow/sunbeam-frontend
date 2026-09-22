import { clearAuthCookie } from "@/backend/lib/auth";
import { NextResponse } from "next/server";

export async function POST() {
  const response = NextResponse.json({ message: "Logged out successfully" });
  clearAuthCookie(response);
  return response;
}
