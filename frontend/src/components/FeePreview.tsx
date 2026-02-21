"use client";
import { useFeeCalculator } from "@/hooks/useFeeCalculator";
import { FEE_TIERS } from "@/lib/constants";

export function FeePreview({ amountUSD }: { amountUSD: number }) {
  const { fee, feeDisplay, netDisplay, percentDisplay, tierDisplay } = useFeeCalculator(amountUSD);
  if (amountUSD <= 0) return <div className="rounded-xl border border-gray-700 bg-gray-800/50 p-4"><p className="text-center text-sm text-gray-400">Enter an amount to see fee preview</p></div>;
  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-gray-700 bg-gray-800/50 p-4 space-y-3">
        <div className="flex justify-between"><span className="text-sm text-gray-400">Transfer Amount</span><span className="text-sm font-medium text-white">${amountUSD.toLocaleString("en-US", { minimumFractionDigits: 2 })} USDC</span></div>
        <div className="flex justify-between"><span className="text-sm text-gray-400">Fee Tier</span><span className="text-sm text-gray-300">{tierDisplay}</span></div>
        <div className="flex justify-between"><span className="text-sm text-gray-400">Fee Rate</span><span className="text-sm font-medium text-yellow-400">{percentDisplay}</span></div>
        <div className="border-t border-gray-700 pt-3"><div className="flex justify-between"><span className="text-sm text-gray-400">Platform Fee</span><span className="text-sm font-medium text-red-400">-{feeDisplay}</span></div></div>
        <div className="border-t border-gray-700 pt-3"><div className="flex justify-between"><span className="text-sm font-medium text-gray-300">You Receive on XDC</span><span className="text-lg font-bold text-green-400">{netDisplay}</span></div></div>
      </div>
      <details className="group"><summary className="cursor-pointer text-xs text-gray-500 hover:text-gray-300">View all fee tiers</summary>
        <div className="mt-2 rounded-lg border border-gray-700 bg-gray-800/30 p-3">
          <table className="w-full text-xs"><thead><tr className="text-gray-500"><th className="pb-2 text-left">Amount</th><th className="pb-2 text-right">Fee</th></tr></thead>
            <tbody className="text-gray-300">{FEE_TIERS.map((tier, i) => (<tr key={i} className={fee.tierLabel === tier.label ? "font-medium text-blue-400" : ""}><td className="py-1">{tier.label}</td><td className="py-1 text-right">{tier.feePercent}%</td></tr>))}</tbody>
          </table>
        </div>
      </details>
    </div>
  );
}
