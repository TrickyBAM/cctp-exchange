"use client";
import { getSourceChains } from "@/config/chains";

const sourceChains = getSourceChains();

export function ChainSelector({ selectedChainId, onSelect }: { selectedChainId: number | null; onSelect: (id: number) => void }) {
  return (
    <div className="space-y-3">
      <label className="text-sm font-medium text-gray-300">From Chain</label>
      <div className="grid grid-cols-3 gap-3">
        {sourceChains.map((chain) => (
          <button key={chain.chainId} onClick={() => onSelect(chain.chainId)}
            className={`flex flex-col items-center gap-2 rounded-xl border-2 px-4 py-4 transition-all ${selectedChainId === chain.chainId ? "border-blue-500 bg-blue-500/10 text-white" : "border-gray-700 bg-gray-800/50 text-gray-300 hover:border-gray-500"}`}>
            <div className={`flex h-10 w-10 items-center justify-center rounded-full text-xs font-bold ${selectedChainId === chain.chainId ? "bg-blue-600 text-white" : "bg-gray-700 text-gray-300"}`}>{chain.shortName}</div>
            <span className="text-sm font-medium">{chain.name}</span>
            <span className="text-xs text-gray-500">Domain {chain.cctpDomain}</span>
          </button>
        ))}
      </div>
      <div className="mt-4 flex items-center gap-2 rounded-lg border border-gray-700 bg-gray-800/50 px-4 py-3">
        <div className="flex h-8 w-8 items-center justify-center rounded-full bg-blue-900 text-xs font-bold text-blue-300">XDC</div>
        <div><p className="text-sm font-medium text-white">To: XDC Network</p><p className="text-xs text-gray-400">Domain 18 | Chain ID 50</p></div>
      </div>
    </div>
  );
}
