import Image from "next/image";
import Link from "next/link";

export default function Header() {
  return (
    <header className="flex items-center justify-between text-slate-100">
      <Link href="/">
        <Image
          src="/logo.jpg"
          alt="sunbeam-logo"
          width={100}
          height={100}
          priority
        />
      </Link>
      <div className="flex gap-5">
        <input
          className="w-dvh placeholder:text-slate-400 text-slate-950 search-bar"
          type="search"
          placeholder="Search your music library"
        />
        <button>Search</button>
      </div>
      <div className="flex gap-5 items-center mx-10">
        <button>
          <Link href="/login">Login</Link>
        </button>
        <button>
          <Link href="/register">Register</Link>
        </button>
      </div>
    </header>
  );
}
