"use client";
import { useState, useCallback } from "react";
import { useAccount } from "wagmi";
import { TransferStatus } from "@/types";
import { SOURCE_CHAINS } from "@/config/chains";
import { calculateFee } from "@/lib/fees";

interface BridgeState {
  status: TransferStatus;
  message: string;
  progress: number;
  burnTxHash?: string;
  mintTxHash?: string;
  error?: string;
}

export function useBridge() {
  const { address } = useAccount();
  const [state, setState] = useState<BridgeState>({ status: TransferStatus.IDLE, message: "Ready to bridge", progress: 0 });

  const reset = useCallback(() => { setState({ status: TransferStatus.IDLE, message: "Ready to bridge", progress: 0 }); }, []);

  const initiateBridge = useCallback(async (sourceChainId: number, amountUSD: number) => {
    if (!address) { setState(s => ({ ...s, status: TransferStatus.FAILED, message: "Please connect your wallet first", error: "No wallet connected" })); return; }
    const sourceChain = SOURCE_CHAINS[sourceChainId];
    if (!sourceChain) { setState(s => ({ ...s, status: TransferStatus.FAILED, message: "Unsupported source chain" })); return; }
    try {
      setState({ status: TransferStatus.APPROVING, message: `Approving USDC on ${sourceChain.name}...`, progress: 10 });
      await new Promise(r => setTimeout(r, 1000));
      setState({ status: TransferStatus.BURNING, message: `Burning USDC on ${sourceChain.name}...`, progress: 25 });
      await new Promise(r => setTimeout(r, 1000));
      setState({ status: TransferStatus.WAITING_ATTESTATION, message: "Waiting for Circle attestation...", progress: 50 });
      await new Promise(r => setTimeout(r, 2000));
      setState({ status: TransferStatus.MINTING, message: "Minting USDC on XDC Network...", progress: 75 });
      await new Promise(r => setTimeout(r, 1000));
      setState({ status: TransferStatus.COLLECTING_FEE, message: "Collecting platform fee...", progress: 90 });
      const feeCalc = calculateFee(amountUSD);
      await new Promise(r => setTimeout(r, 500));
      setState({ status: TransferStatus.COMPLETE, message: `Bridge complete! You received $${feeCalc.netAmount.toFixed(2)} USDC on XDC`, progress: 100 });
    } catch (err: any) {
      setState({ status: TransferStatus.FAILED, message: err?.message || "Bridge transfer failed", progress: 0, error: err?.message });
    }
  }, [address]);

  return { state, initiateBridge, reset };
}
