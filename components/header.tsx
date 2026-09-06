import Image from "next/image";
import Link from "next/link";

export default function header() {
    return (
        <header className="flex items-center justify-between text-slate-100">
            <Link href="/">
                <Image src="/logo.jpg" alt="sunbeam-logo" width={100} height={100} priority />
            </Link>
            <input className="w-dvh placeholder:text-slate-400 text-slate-950 search-bar"type="search" placeholder="Search your music library" />
            <div className="flex items-center mx-10">

                <Link className="text-lg" href="/">
                    Welcome User!
                </Link>
            </div>
        </header>
    )
}