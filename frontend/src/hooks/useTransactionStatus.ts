"use client";
import { useState } from "react";
import { TransferStatus } from "@/types";

export function useTransactionStatus(burnTxHash: string | undefined, sourceDomain: number | undefined) {
  const [state] = useState({
    status: TransferStatus.IDLE,
    message: "Ready to bridge",
    progress: 0,
    attestationReady: false,
  });
  return state;
}
