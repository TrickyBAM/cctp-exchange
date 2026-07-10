"use client";
import { useState } from "react";
import { TransferStatus } from "@/types";

export function useTransactionStatus(burnTxHash: string | undefined, sourceDomain: number | undefined) {
  const [state] = useState({
    status: TransferStatus.FAILED,
    message: "Transaction tracking is disabled. This site is a preserved product demo only.",
    progress: 0,
    attestationReady: false,
    error: "DEMO_LOCKED",
  });
  return state;
}
