import { BridgeForm } from "@/components/BridgeForm";

export default function Home() {
  return (
    <div className="flex flex-col items-center justify-center px-4 py-12">
      <div className="mb-8 text-center">
        <h1 className="mb-2 text-4xl font-bold text-white">USDC to XDC bridge concept</h1>
        <p className="text-lg text-gray-400">A locked, non-transactional product prototype preserved for future work</p>
      </div>
      <BridgeForm />
      <div className="mt-16 grid max-w-4xl grid-cols-1 gap-6 md:grid-cols-3">
        <div className="rounded-xl border border-gray-700 bg-gray-800/30 p-6 text-center"><h3 className="mb-2 text-lg font-semibold text-white">Product concept</h3><p className="text-sm text-gray-400">Shows how a native-USDC route to XDC could be presented to a user.</p></div>
        <div className="rounded-xl border border-gray-700 bg-gray-800/30 p-6 text-center"><h3 className="mb-2 text-lg font-semibold text-white">Illustrative fees</h3><p className="text-sm text-gray-400">Lets you explore the proposed tiered-fee design without requesting a quote.</p></div>
        <div className="rounded-xl border border-gray-700 bg-gray-800/30 p-6 text-center"><h3 className="mb-2 text-lg font-semibold text-white">Safely shelved</h3><p className="text-sm text-gray-400">Wallet and transaction actions are removed until the project is deliberately restarted.</p></div>
      </div>
    </div>
  );
}
