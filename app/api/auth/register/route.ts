import { generateToken, hashPassword, setAuthCookie } from "@/backend/lib/auth";
import { prisma } from "@/backend/lib/prisma";
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
    // Emails and usernames must be unique
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
    const hashedPassword = await hashPassword(password);

    const user = await prisma.user.create({
      data: {
        email: email.trim(),
        username: username.trim(),
        password: hashedPassword,
      },
    });

    // Generate token
    const token = generateToken({
      id: user.id,
      email: user.email,
      username: user.username,
    });

    // Create response with httpOnly cookie
    const response = NextResponse.json(
      {
        message: "User registered successfully",
        user: {
          id: user.id,
          email: user.email,
          username: user.username,
        },
      },
      { status: 201 },
    );

    // Set httpOnly cookie
    setAuthCookie(response, token);
    return response;
  } catch (error) {
    console.error("Registration error:", error);

    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 },
    );
  }
}
