export function DemoNotice() {
  return (
    <div
      role="status"
      className="rounded-xl border border-amber-400/50 bg-amber-400/10 px-4 py-3 text-left"
    >
      <div className="flex items-start gap-3">
        <span
          aria-hidden="true"
          className="mt-0.5 rounded-md bg-amber-400 px-2 py-0.5 text-xs font-black tracking-wide text-gray-950"
        >
          DEMO
        </span>
        <div>
          <p className="font-semibold text-amber-100">Prototype locked — no funds can move</p>
          <p className="mt-1 text-sm leading-5 text-amber-100/80">
            This site is preserved as a product demo only. Wallet connections and transactions are disabled.
            Do not send USDC or other assets to any address shown in this prototype.
          </p>
        </div>
      </div>
    </div>
  );
}
