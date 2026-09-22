import Image from "next/image";
import Link from "next/link";

export default function Home() {
  return (
    <div>
      <div
        className="justify-items-center"
        style={{
          position: "relative",
          width: "100vw",
          height: "100vh",
        }}
      >
        <Image
          src="/background-logo.png"
          width={675}
          height={675}
          alt={"Background Image"}
        />

        <div
          style={{
            position: "absolute",
            top: "5%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            zIndex: 1,
          }}
          className="text-zinc-100"
        >
          <h1 className="text-4xl font-semibold">Sunbeam</h1>
        </div>
        <div className="flex gap-5">
          <button>
            <Link href="/login">Login</Link>
          </button>
          <button>
            <Link href="/register">Register</Link>
          </button>
        </div>
      </div>
    </div>
  );
}
