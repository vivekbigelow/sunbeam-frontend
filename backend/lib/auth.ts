import bcrypt from "bcrypt";
import { cookies } from "next/headers";
import { NextResponse } from "next/server";

const SALT_ROUNDS = 12;
const TOKEN_EXPIARY_HOURS = parseInt(
  process.env.AUTH_TOKEN_EXPIARY_HOURS || "24",
);
const AUTH_COOKIE_NAME = "auth_token";

export interface TokenPayload {
  userId: number;
  email: string;
  username: string;
  exp: number;
}

// Hash a password using bcrypt
export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

// Verify a password against a hash
export async function verifyPassword(
  password: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

// Generate a base64 encoded token with expiration
// Not for production
export function generateToken(user: {
  id: number;
  email: string;
  username: string;
}): string {
  const payload: TokenPayload = {
    userId: user.id,
    email: user.email,
    username: user.username,
    exp: Date.now() + TOKEN_EXPIARY_HOURS * 60 * 60 * 1000,
  };
  return Buffer.from(JSON.stringify(payload)).toString("base64");
}

// Verify and decode a token
export function verifyToken(token: string): TokenPayload | null {
  try {
    const payload = JSON.parse(
      Buffer.from(token, "base64").toString("utf-8"),
    ) as TokenPayload;

    //check expiration
    if (payload.exp < Date.now()) {
      return null;
    }

    return payload;
  } catch {
    return null;
  }
}

// Set auth cookie (httpOnly, secure in production)
export function setAuthCookie(response: NextResponse, token: string): void {
  response.cookies.set(AUTH_COOKIE_NAME, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    maxAge: TOKEN_EXPIARY_HOURS * 60 * 60, // in seconds
    path: "/",
  });
}

// Clear auth cookie
export function clearAuthCookie(response: NextResponse): void {
  response.cookies.set(AUTH_COOKIE_NAME, "", {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    maxAge: 0,
    path: "/",
  });
}

// Get auth token from cookies (for server components/actions)
export async function getAuthToken(): Promise<string | null> {
  const cookieStore = await cookies();
  return cookieStore.get(AUTH_COOKIE_NAME)?.value ?? null;
}

// Get current user from cookie (for server components/actions)
export async function getCurrentUser(): Promise<TokenPayload | null> {
  const token = await getAuthToken();
  if (!token) return null;
  return verifyToken(token);
}

// Extract token from cookie in request
export function extractTokenFromRequest(request: Request): string | null {
  const cookieHeader = request.headers.get("cookie");
  if (!cookieHeader) return null;

  const cookies = cookieHeader.split(";").reduce(
    (acc, cookie) => {
      const [key, value] = cookie.trim().split("=");
      acc[key] = value;
      return acc;
    },
    {} as Record<string, string>,
  );

  return cookies[AUTH_COOKIE_NAME] ?? null;
}
