"use client";
import { useState } from "react";
import { useAccount } from "wagmi";
import { ChainSelector } from "./ChainSelector";
import { FeePreview } from "./FeePreview";
import { TransactionStatus } from "./TransactionStatus";
import { WalletButton } from "./WalletButton";
import { useBridge } from "@/hooks/useBridge";
import { TransferStatus } from "@/types";

export function BridgeForm() {
  const { isConnected } = useAccount();
  const { state, initiateBridge, reset } = useBridge();
  const [selectedChainId, setSelectedChainId] = useState<number | null>(null);
  const [amount, setAmount] = useState("");
  const amountUSD = parseFloat(amount) || 0;
  const canBridge = isConnected && selectedChainId !== null && amountUSD > 0 && state.status === TransferStatus.IDLE;
  const isProcessing = ![TransferStatus.IDLE, TransferStatus.COMPLETE, TransferStatus.FAILED].includes(state.status);

  return (
    <div className="mx-auto max-w-lg space-y-6">
      <div className="rounded-2xl border border-gray-700 bg-gray-900 p-6 shadow-xl">
        <h2 className="mb-6 text-center text-xl font-bold text-white">Bridge USDC to XDC</h2>
        <div className="mb-6"><ChainSelector selectedChainId={selectedChainId} onSelect={setSelectedChainId} /></div>
        <div className="mb-6 space-y-2">
          <label className="text-sm font-medium text-gray-300">Amount (USDC)</label>
          <div className="relative">
            <input type="number" value={amount} onChange={e => setAmount(e.target.value)} placeholder="0.00" min="0" step="0.01" disabled={isProcessing}
              className="w-full rounded-xl border border-gray-700 bg-gray-800 px-4 py-4 pr-20 text-xl font-medium text-white placeholder-gray-500 focus:border-blue-500 focus:outline-none disabled:opacity-50" />
            <span className="absolute right-4 top-1/2 -translate-y-1/2 text-sm font-medium text-gray-400">USDC</span>
          </div>
          <div className="flex gap-2">
            {[100, 500, 1000, 5000].map(val => (
              <button key={val} onClick={() => setAmount(val.toString())} disabled={isProcessing}
                className="rounded-lg border border-gray-700 bg-gray-800 px-3 py-1 text-xs text-gray-300 hover:border-gray-500 hover:text-white disabled:opacity-50">${val.toLocaleString()}</button>
            ))}
          </div>
        </div>
        <div className="mb-6"><FeePreview amountUSD={amountUSD} /></div>
        {!isConnected ? <WalletButton /> :
          state.status === TransferStatus.COMPLETE || state.status === TransferStatus.FAILED ? (
            <button onClick={() => { reset(); setAmount(""); setSelectedChainId(null); }} className="w-full rounded-xl bg-gray-700 px-6 py-4 text-lg font-semibold text-white hover:bg-gray-600 active:scale-[0.98]">{state.status === TransferStatus.COMPLETE ? "Bridge Again" : "Try Again"}</button>
          ) : (
            <button onClick={() => canBridge && selectedChainId && initiateBridge(selectedChainId, amountUSD)} disabled={!canBridge || isProcessing}
              className="w-full rounded-xl bg-blue-600 px-6 py-4 text-lg font-semibold text-white hover:bg-blue-500 active:scale-[0.98] disabled:cursor-not-allowed disabled:opacity-50">{isProcessing ? "Processing..." : "Bridge to XDC"}</button>
          )
        }
      </div>
      <TransactionStatus status={state.status} message={state.message} progress={state.progress} error={state.error} />
      <div className="text-center text-xs text-gray-500"><p>Powered by Circle CCTP V2 | Standard Transfer</p><p>Fees are collected after USDC is minted on XDC</p></div>
    </div>
  );
}
