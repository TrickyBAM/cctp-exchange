import { BridgeForm } from "@/components/BridgeForm";

export default function Home() {
  return (
    <div className="flex flex-col items-center justify-center px-4 py-12">
      <div className="mb-8 text-center">
        <h1 className="mb-2 text-4xl font-bold text-white">Bridge USDC to XDC</h1>
        <p className="text-lg text-gray-400">Fast, secure cross-chain transfers powered by Circle CCTP V2</p>
      </div>
      <BridgeForm />
      <div className="mt-16 grid max-w-4xl grid-cols-1 gap-6 md:grid-cols-3">
        <div className="rounded-xl border border-gray-700 bg-gray-800/30 p-6 text-center"><h3 className="mb-2 text-lg font-semibold text-white">Native USDC</h3><p className="text-sm text-gray-400">No wrapped tokens. Circle mints real USDC directly on XDC Network.</p></div>
        <div className="rounded-xl border border-gray-700 bg-gray-800/30 p-6 text-center"><h3 className="mb-2 text-lg font-semibold text-white">Low Fees</h3><p className="text-sm text-gray-400">Tiered fees from 1% down to 0.01% for large transfers.</p></div>
        <div className="rounded-xl border border-gray-700 bg-gray-800/30 p-6 text-center"><h3 className="mb-2 text-lg font-semibold text-white">Secure</h3><p className="text-sm text-gray-400">Upgradeable contracts with role-based access and reentrancy protection.</p></div>
      </div>
    </div>
  );
}
