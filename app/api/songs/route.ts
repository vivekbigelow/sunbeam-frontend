import { prisma } from "@/backend/lib/prisma";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  try {
    const songs = await prisma.song.findMany({
      select: {
        title: true,
        artist: true,
        album: true,
      },
    });

    return NextResponse.json(songs);
  } catch (error) {
    console.error("Error fetching songs:", error);
    return NextResponse.json(
      { error: "Failed to fetch songs" },
      { status: 500 },
    );
  }
}
