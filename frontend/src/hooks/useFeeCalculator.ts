"use client";
import { useMemo } from "react";
import { calculateFee, formatUSD } from "@/lib/fees";

export function useFeeCalculator(amountUSD: number) {
  const fee = useMemo(() => calculateFee(amountUSD), [amountUSD]);
  return {
    fee,
    feeDisplay: formatUSD(fee.feeAmount),
    netDisplay: formatUSD(fee.netAmount),
    percentDisplay: `${fee.feePercent.toFixed(2)}%`,
    tierDisplay: fee.tierLabel,
  };
}
