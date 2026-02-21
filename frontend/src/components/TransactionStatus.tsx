"use client";
import { TransferStatus } from "@/types";

const STEPS = [
  { key: TransferStatus.APPROVING, label: "Approve", icon: "1" },
  { key: TransferStatus.BURNING, label: "Burn", icon: "2" },
  { key: TransferStatus.WAITING_ATTESTATION, label: "Attest", icon: "3" },
  { key: TransferStatus.MINTING, label: "Mint", icon: "4" },
  { key: TransferStatus.COLLECTING_FEE, label: "Fee", icon: "5" },
  { key: TransferStatus.COMPLETE, label: "Done", icon: "6" },
];

export function TransactionStatus({ status, message, progress, error }: { status: TransferStatus; message: string; progress: number; error?: string }) {
  if (status === TransferStatus.IDLE) return null;
  const isFailed = status === TransferStatus.FAILED;
  const isComplete = status === TransferStatus.COMPLETE;
  return (
    <div className="space-y-4 rounded-xl border border-gray-700 bg-gray-800/50 p-6">
      <div className="h-2 w-full overflow-hidden rounded-full bg-gray-700">
        <div className={`h-full rounded-full transition-all duration-500 ${isFailed ? "bg-red-500" : isComplete ? "bg-green-500" : "bg-blue-500"}`} style={{ width: `${progress}%` }} />
      </div>
      <div className="flex justify-between">
        {STEPS.map((step) => {
          const stepIdx = STEPS.findIndex(s => s.key === step.key);
          const curIdx = STEPS.findIndex(s => s.key === status);
          const isPast = curIdx > stepIdx;
          const isCurrent = step.key === status;
          return (
            <div key={step.key} className="flex flex-col items-center gap-1">
              <div className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold ${isPast || isComplete ? "bg-green-600 text-white" : isCurrent ? "bg-blue-600 text-white animate-pulse" : "bg-gray-700 text-gray-400"}`}>{isPast || isComplete ? "\u2713" : step.icon}</div>
              <span className={`text-xs ${isCurrent ? "font-medium text-white" : "text-gray-500"}`}>{step.label}</span>
            </div>
          );
        })}
      </div>
      <div className={`rounded-lg px-4 py-3 text-center text-sm ${isFailed ? "bg-red-900/30 text-red-300" : isComplete ? "bg-green-900/30 text-green-300" : "bg-blue-900/30 text-blue-300"}`}>{message}</div>
      {error && <details className="text-xs"><summary className="cursor-pointer text-red-400">Error details</summary><pre className="mt-2 overflow-auto rounded bg-gray-900 p-2 text-red-300">{error}</pre></details>}
    </div>
  );
}
