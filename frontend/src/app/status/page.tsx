"use client";
import { useState } from "react";

export default function StatusPage() {
  const [txHash, setTxHash] = useState("");
  const [isSearching, setIsSearching] = useState(false);
  const handleSearch = () => { if (!txHash) return; setIsSearching(true); setTimeout(() => setIsSearching(false), 2000); };
  return (
    <div className="flex flex-col items-center px-4 py-12">
      <h1 className="mb-2 text-3xl font-bold text-white">Transaction Status</h1>
      <p className="mb-8 text-gray-400">Track your CCTP bridge transfer</p>
      <div className="w-full max-w-lg flex gap-3">
        <input type="text" value={txHash} onChange={e => setTxHash(e.target.value)} placeholder="Enter burn transaction hash..."
          className="flex-1 rounded-xl border border-gray-700 bg-gray-800 px-4 py-3 text-sm text-white placeholder-gray-500 focus:border-blue-500 focus:outline-none" />
        <button onClick={handleSearch} disabled={!txHash || isSearching}
          className="rounded-xl bg-blue-600 px-6 py-3 text-sm font-medium text-white hover:bg-blue-500 disabled:opacity-50">{isSearching ? "Searching..." : "Search"}</button>
      </div>
      <div className="mt-16 w-full max-w-2xl space-y-4">
        <h2 className="text-center text-xl font-semibold text-white">How Bridge Transfers Work</h2>
        {[{ n: 1, t: "Burn", d: "Your USDC is burned on the source chain." }, { n: 2, t: "Attestation", d: "Circle observes the burn and issues a signed confirmation (1-5 min)." }, { n: 3, t: "Mint", d: "New USDC is minted on XDC Network to your wallet." }, { n: 4, t: "Fee", d: "The platform fee is deducted from your received USDC." }].map(s => (
          <div key={s.n} className="flex gap-4"><div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-blue-600 text-sm font-bold text-white">{s.n}</div><div><h3 className="font-medium text-white">{s.t}</h3><p className="text-sm text-gray-400">{s.d}</p></div></div>
        ))}
      </div>
    </div>
  );
}
