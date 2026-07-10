export function Header() {
  return (
    <header className="border-b border-gray-800 bg-gray-900/80 backdrop-blur-sm">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-600 font-bold text-white">C</div>
          <div>
            <h1 className="text-lg font-bold text-white">CCTP.Valid</h1>
            <p className="text-xs text-gray-400">Preserved bridge prototype</p>
          </div>
        </div>
        <nav className="hidden items-center gap-6 md:flex">
          <a href="/" className="text-sm text-gray-300 hover:text-white">Bridge</a>
          <a href="/status" className="text-sm text-gray-300 hover:text-white">How it works</a>
        </nav>
        <div className="rounded-full border border-amber-400/50 bg-amber-400/10 px-3 py-1.5 text-xs font-bold tracking-wide text-amber-200">
          DEMO · LOCKED
        </div>
      </div>
    </header>
  );
}
