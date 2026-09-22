import { prisma } from "@/backend/lib/prisma";
import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const { name, bio, imageUrl } = body;

    // Basic Validation
    if (typeof name !== "string" || !name.trim() || name.trim() === "") {
      return NextResponse.json(
        { error: "Artist name is required" },
        { status: 400 },
      );
    }

    const artistName = name.trim();

    // Check whether an artist with this name already exists
    const existingArtists = await prisma.artist.findMany({
      where: {
        name: {
          equals: artistName,
          mode: "insensitive",
        },
      },
      select: {
        id: true,
        name: true,
        bio: true,
        imageUrl: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    // If matches exist, don't automatically create another artist
    if (existingArtists.length > 0) {
      return NextResponse.json(
        { error: "An artist with this name already exists", existingArtists },
        { status: 409 },
      );
    }

    // Create the artist
    const artist = await prisma.artist.create({
      data: {
        name: artistName,
        bio: bio || null,
        imageUrl: imageUrl || null,
      },
    });

    return NextResponse.json(artist, { status: 201 });
  } catch (error) {
    console.error("Error creating artist:", error);

    return NextResponse.json(
      { error: "Failed to create artist" },
      { status: 500 },
    );
  }
}

export async function GET() {
  try {
    const artists = await prisma.artist.findMany({
      orderBy: {
        name: "asc",
      },
      select: {
        id: true,
        name: true,
        bio: true,
        imageUrl: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    return NextResponse.json(artists, { status: 200 });
  } catch (error) {
    console.error("Error fetching artists", error);

    return NextResponse.json(
      { error: "Failed to fetch artists" },
      { status: 500 },
    );
  }
}
