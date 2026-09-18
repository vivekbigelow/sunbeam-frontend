import { prisma } from "@/backend/lib/prisma";
import bcrypt from "bcrypt";
import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const { email, username, password } = body;

    // Basic Validation
    if (
      typeof email !== "string" ||
      typeof username !== "string" ||
      typeof password !== "string" ||
      !email.trim() ||
      !password ||
      !username.trim()
    ) {
      return NextResponse.json(
        { error: "Email, password, and username are required" },
        { status: 400 },
      );
    }

    // Check if the user already exists
    // Emails and Usernames must be unique
    const existingEmail = await prisma.user.findUnique({
      where: { email },
    });

    if (existingEmail) {
      return NextResponse.json(
        { error: "User with this email already exists." },
        { status: 409 },
      );
    }

    const existingUserName = await prisma.user.findUnique({
      where: { username },
    });

    if (existingUserName) {
      return NextResponse.json(
        { error: "This Username is already in use." },
        { status: 409 },
      );
    }

    // Hash the password before storing it
    const hashedPassword = await bcrypt.hash(password, 12);

    const user = await prisma.user.create({
      data: {
        email: email.trim(),
        username: username.trim(),
        password: hashedPassword,
      },
      select: {
        id: true,
        username: true,
        createdAt: true,
      },
    });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    console.error("Error creating user:", error);

    return NextResponse.json(
      { error: "failed to create user" },
      { status: 500 },
    );
  }
}
