"use client";
import { useState, useCallback } from "react";
import { TransferStatus } from "@/types";

interface BridgeState {
  status: TransferStatus;
  message: string;
  progress: number;
  burnTxHash?: string;
  mintTxHash?: string;
  error?: string;
}

const LOCKED_STATE: BridgeState = {
  status: TransferStatus.FAILED,
  message: "Transactions are disabled. This site is a preserved product demo only.",
  progress: 0,
  error: "DEMO_LOCKED",
};

export function useBridge() {
  const [state, setState] = useState<BridgeState>(LOCKED_STATE);

  const reset = useCallback(() => { setState(LOCKED_STATE); }, []);

  const initiateBridge = useCallback(async () => {
    setState(LOCKED_STATE);
  }, []);

  return { state, initiateBridge, reset };
}
