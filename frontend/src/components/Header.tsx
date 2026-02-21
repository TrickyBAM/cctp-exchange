"use client";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export function Header() {
  return (
    <header className="border-b border-gray-800 bg-gray-900/80 backdrop-blur-sm">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-600 font-bold text-white">C</div>
          <div>
            <h1 className="text-lg font-bold text-white">CCTP.Valid</h1>
            <p className="text-xs text-gray-400">USDC Bridge to XDC</p>
          </div>
        </div>
        <nav className="hidden items-center gap-6 md:flex">
          <a href="/" className="text-sm text-gray-300 hover:text-white">Bridge</a>
          <a href="/status" className="text-sm text-gray-300 hover:text-white">Status</a>
        </nav>
        <ConnectButton chainStatus="icon" showBalance={false} accountStatus="address" />
      </div>
    </header>
  );
}
