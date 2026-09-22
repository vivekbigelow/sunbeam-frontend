"use client";
import Link from "next/link";
import { useState } from "react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useAuth } from "@/app/hooks/useAuth";

export default function RegisterPage() {
  const router = useRouter();
  const { register, isAuthenticated, isLoading } = useAuth();
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
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

    if (password !== confirmPassword) {
      setMessage("Passwords do not match");
      return;
    }

    if (password.length < 6) {
      setMessage("Password must be at least 6 characters");
      return;
    }

    setIsSubmitting(true);

    try {
      await register({ email, password, username });
      router.push("/dashboard");
      // const response = await fetch("api/users", {
      //   method: "POST",
      //   headers: {
      //     "Content-Type": "application/json",
      //   },
      //   body: JSON.stringify({
      //     email,
      //     username,
      //     password,
      //   }),
      // });
      // const data = await response.json();
      // if (!response.ok) {
      //   setMessage(data.error || "Something went wrong.");
      //   return;
      // }

      // console.log("User created:", data);
      // setMessage("Account created successfully!");

      // setEmail("");
      // setUsername("");
      // setPassword("");
      // setConfirmPassword("");
    } catch (error) {
      setMessage(
        error instanceof Error ? error.message : "Registration failed",
      );
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
            <span className="title-bar-text">Create Your Account</span>
          </div>
          <div className="mt-1 mb-2 mx-5">
            <form onSubmit={handleSubmit}>
              <div className="flex flex-col gap-1">
                <label htmlFor="email">Email</label>
                <input
                  type="email"
                  placeholder="you@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-fit"
                />
              </div>

              <div className="flex flex-col gap-1">
                <label htmlFor="username">Username</label>
                <input
                  type="text"
                  placeholder="User Name"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  required
                  className="w-fit"
                />
              </div>

              <div className="flex flex-col gap-1">
                <label htmlFor="password">Password</label>
                <input
                  type="password"
                  placeholder="Password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="w-fit"
                />
              </div>

              <div className="flex flex-col gap-1">
                <label htmlFor="confirmpassword">Confirm Password</label>
                <input
                  type="password"
                  placeholder="Confirm Password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  className="w-fit"
                />
              </div>
              <div className="flex gap-4 my-3">
                <button type="submit" disabled={isSubmitting}>
                  {isSubmitting ? <span>Loading</span> : "Create Account"}
                </button>
              </div>

              {message && <p>{message}</p>}
            </form>
            <p>
              Already have an account? <Link href="/login">Sign in</Link>
            </p>
          </div>
        </div>
      </div>
    </>
  );
}
