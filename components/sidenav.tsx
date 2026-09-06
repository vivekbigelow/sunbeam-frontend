'use client';

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Fragment } from "react/jsx-runtime";

export default function Sidenav () {
    const pathname = usePathname();

    function isNavItemActive(pathname: string, nav: string) {
        return pathname.includes(nav);
    }

    const navItems = [
        {
            name: 'Home',
            href: '/',
            active: pathname === '/',
            position: 'top',

        },
        {
            name: 'Songs',
            href: '/songs',
            active: isNavItemActive(pathname, '/songs'),
            position: 'top',

        },
        {
            name: 'Albums',
            href: '/albums',
            active: isNavItemActive(pathname, '/albums'),
            position: 'top',

        },
        {
            name: 'Artists',
            href: '/artists',
            active: isNavItemActive(pathname, '/artists'),
            position: 'top',

        },
        {
            name: 'Playlists',
            href: '/playlists',
            active: isNavItemActive(pathname, '/playlists'),
            position: 'top',

        },


    ]
    return (
        <div className="w-sm bg-white border-r-2">
            <aside className="flex h-full flex-col w-full break-words px-4 overflow-x-hidden columns-1">
                {/* Top */}
                <div>
                    <div>
                        {navItems.map((item, idx) => {
                            if (item.position === 'top') {
                                return (
                                    <Fragment key={idx}>
                                        <div className="space-y-1">
                                            <SideNavItem 
                                                label={item.name}
                                                path={item.href}
                                                active={item.active}
                                            />
                                        </div>
                                    </Fragment>
                                )
                            }
                        })}
                    </div>
                </div>
            </aside>
        </div>
    )
}

export const SideNavItem: React.FC<{
    label: string;
    path: string;
    active: boolean;
}> = ({label, path, active}) => {
    return (
        <>
            <Link href={path}>
                <div>
                    <span className={`${active ? 'text-slate-950' : 'text-slate-400'}`}>{label}</span>
                </div>
            </Link>
        </>
    )
}