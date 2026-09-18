import { prisma } from "@/backend/lib/prisma";
import { NextRequest, NextResponse } from "next/server";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> },
) {
  try {
    const { id } = await params;

    const userId: number = Number(id);

    if (!Number.isInteger(userId)) {
      return NextResponse.json({ error: "Invalid user ID" }, { status: 400 });
    }

    const user = await prisma.user.findUnique({
      where: {
        id: userId,
      },
      select: {
        id: true,
        username: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      return NextResponse.json({ error: "User not found" }, { status: 404 });
    }

    return NextResponse.json(user, { status: 200 });
  } catch (error) {
    console.error("Error fetching user:", error);

    return NextResponse.json(
      { error: "Failed to fetch user" },
      { status: 500 },
    );
  }
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> },
) {
  try {
    const { id } = await params;

    const userId: number = Number(id);

    if (!Number.isInteger(userId)) {
      return NextResponse.json({ error: "Invalid user ID" }, { status: 400 });
    }

    const body = await request.json();

    const { username, email } = body;

    // Check if the user already exists
    // Emails and Usernames must be unique
    if (email) {
      const existingEmail = await prisma.user.findUnique({
        where: { email },
      });

      if (existingEmail) {
        return NextResponse.json(
          { error: "User with this email already exists." },
          { status: 409 },
        );
      }
    }
    if (username) {
      const existingUserName = await prisma.user.findUnique({
        where: { username },
      });

      if (existingUserName) {
        return NextResponse.json(
          { error: "This Username is already in use." },
          { status: 409 },
        );
      }
    }

    const user = await prisma.user.update({
      where: {
        id: userId,
      },
      data: {
        username,
        email,
      },
      select: {
        id: true,
        email: true,
        username: true,
        createdAt: true,
        updatedAt: true,
      },
    });
    return NextResponse.json(user, { status: 200 });
  } catch (error) {
    console.error("Error updating user:", error);

    return NextResponse.json(
      { error: "Failed to update user" },
      { status: 500 },
    );
  }
}
