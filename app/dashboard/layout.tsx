import Header from "@/components/Header";
import Sidenav from "@/components/Sidenav";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      <Header />
      <div className="flex min-h-dvh mx-auto">
        <Sidenav />
        <div className="flex w-full max-w[1100px] flex-col border-x border-zinc-300 bg-white">
          <main className="px-4 py-8">{children}</main>
        </div>
      </div>
    </div>
  );
}
