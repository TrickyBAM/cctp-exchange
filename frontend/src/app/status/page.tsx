import { DemoNotice } from "@/components/DemoNotice";

export default function StatusPage() {
  return (
    <div className="flex flex-col items-center px-4 py-12">
      <div className="w-full max-w-2xl">
        <h1 className="mb-2 text-center text-3xl font-bold text-white">How the concept was designed</h1>
        <p className="mb-8 text-center text-gray-400">There are no live or simulated transaction-status searches.</p>
        <DemoNotice />
      </div>
      <div className="mt-16 w-full max-w-2xl space-y-4">
        <h2 className="text-center text-xl font-semibold text-white">Proposed transfer flow</h2>
        {[{ n: 1, t: "Approve and burn", d: "A future implementation would request explicit wallet approval, then burn source-chain USDC." }, { n: 2, t: "Attestation", d: "A future implementation would obtain and verify Circle's signed attestation." }, { n: 3, t: "Mint", d: "A future implementation would submit the attestation to mint destination-chain USDC." }, { n: 4, t: "Verify", d: "A production product would show real transaction hashes, confirmations, final amounts, and failure recovery." }].map(s => (
          <div key={s.n} className="flex gap-4"><div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-blue-600 text-sm font-bold text-white">{s.n}</div><div><h3 className="font-medium text-white">{s.t}</h3><p className="text-sm text-gray-400">{s.d}</p></div></div>
        ))}
      </div>
    </div>
  );
}
