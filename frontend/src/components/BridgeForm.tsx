"use client";
import { useState } from "react";
import { ChainSelector } from "./ChainSelector";
import { DemoNotice } from "./DemoNotice";
import { FeePreview } from "./FeePreview";

export function BridgeForm() {
  const [selectedChainId, setSelectedChainId] = useState<number | null>(null);
  const [amount, setAmount] = useState("");
  const amountUSD = parseFloat(amount) || 0;

  return (
    <div className="mx-auto max-w-lg space-y-6">
      <DemoNotice />
      <div className="rounded-2xl border border-gray-700 bg-gray-900 p-6 shadow-xl">
        <div className="mb-6 text-center">
          <h2 className="text-xl font-bold text-white">Explore the bridge concept</h2>
          <p className="mt-1 text-sm text-gray-400">Try the fee estimator. It cannot submit a transaction.</p>
        </div>
        <div className="mb-6"><ChainSelector selectedChainId={selectedChainId} onSelect={setSelectedChainId} /></div>
        <div className="mb-6 space-y-2">
          <label htmlFor="demo-amount" className="text-sm font-medium text-gray-300">Demo amount (USDC)</label>
          <div className="relative">
            <input id="demo-amount" type="number" value={amount} onChange={e => setAmount(e.target.value)} placeholder="0.00" min="0" step="0.01"
              className="w-full rounded-xl border border-gray-700 bg-gray-800 px-4 py-4 pr-20 text-xl font-medium text-white placeholder-gray-500 focus:border-blue-500 focus:outline-none disabled:opacity-50" />
            <span className="absolute right-4 top-1/2 -translate-y-1/2 text-sm font-medium text-gray-400">USDC</span>
          </div>
          <div className="flex gap-2">
            {[100, 500, 1000, 5000].map(val => (
              <button key={val} type="button" onClick={() => setAmount(val.toString())}
                className="rounded-lg border border-gray-700 bg-gray-800 px-3 py-1 text-xs text-gray-300 hover:border-gray-500 hover:text-white disabled:opacity-50">${val.toLocaleString()}</button>
            ))}
          </div>
        </div>
        <div className="mb-6"><FeePreview amountUSD={amountUSD} /></div>
        <button
          type="button"
          disabled
          aria-describedby="transaction-lock-explanation"
          className="w-full cursor-not-allowed rounded-xl border border-gray-600 bg-gray-800 px-6 py-4 text-lg font-semibold text-gray-400"
        >
          Transactions disabled — demo only
        </button>
        <p id="transaction-lock-explanation" className="mt-3 text-center text-xs leading-5 text-gray-500">
          No wallet connection, approval, burn, attestation, mint, or fee collection occurs.
        </p>
      </div>
      <div className="text-center text-xs text-gray-500">
        <p>Concept UI based on a possible Circle CCTP flow</p>
        <p>Fee figures are illustrative and are not an offer or transaction quote</p>
      </div>
    </div>
  );
}
