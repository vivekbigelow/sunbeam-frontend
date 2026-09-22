"use client";
import Link from "next/link";
import { useState } from "react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useAuth } from "@/app/hooks/useAuth";

export default function LoginPage() {
  const router = useRouter();
  const { login, isAuthenticated, isLoading } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Redirect if already authenticated
  if (!isLoading && isAuthenticated) {
    router.push("/dashboard");
    return null;
  }

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setMessage("");
    setIsSubmitting(true);

    try {
      await login({ email, password });
      router.push("/dashboard");
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Login failed");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <>
      <h1 className="z-10 absolute top-0.05 left-1/2 transform -translate-x-1/2 text-white text-4xl font-semibold">
        Sunbeam
      </h1>
      <div className="relative w-vw h-vh text-black grid place-items-center">
        <Image
          src="/background-logo.png"
          width={675}
          height={675}
          alt={"Background Image"}
        />
        <div className="window z-10 absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
          <div className="title-bar">
            <span className="title-bar-text">Sign In</span>
          </div>
          <div className="mt-1 mb-2 mx-5">
            <form onSubmit={handleSubmit}>
              <div className="flex flex-col gap-1">
                <label htmlFor="email">Email</label>
                <input
                  type="email"
                  placeholder="Enter your email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-fit"
                />
              </div>
              <div className="flex flex-col gap-1">
                <label htmlFor="password">Password</label>
                <input
                  type="password"
                  placeholder="******"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="w-fit"
                />
              </div>
              <div className="flex gap-4 my-3">
                <button type="submit" disabled={isSubmitting}>
                  {isSubmitting ? <span>Loading</span> : "Login"}
                </button>
              </div>
              {message && <p>{message}</p>}
            </form>
            <p>
              Don&apos;t have an account? <Link href="/register">Sign Up</Link>
            </p>
          </div>
        </div>
      </div>
    </>
  );
}
