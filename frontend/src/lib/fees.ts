import { FEE_TIERS } from "./constants";
import type { FeeCalculation } from "@/types";

export function calculateFee(amountUSD: number): FeeCalculation {
  if (amountUSD <= 0) return { amount: 0, feePercent: 0, feeAmount: 0, netAmount: 0, tierLabel: "Enter amount" };
  for (const tier of FEE_TIERS) {
    if (amountUSD <= tier.maxAmountUSD) {
      const feeAmount = (amountUSD * tier.feeBasisPoints) / 10_000;
      return {
        amount: amountUSD,
        feePercent: tier.feePercent,
        feeAmount: Math.round(feeAmount * 100) / 100,
        netAmount: Math.round((amountUSD - feeAmount) * 100) / 100,
        tierLabel: tier.label,
      };
    }
  }
  const lastTier = FEE_TIERS[FEE_TIERS.length - 1];
  const feeAmount = (amountUSD * lastTier.feeBasisPoints) / 10_000;
  return { amount: amountUSD, feePercent: lastTier.feePercent, feeAmount: Math.round(feeAmount * 100) / 100, netAmount: Math.round((amountUSD - feeAmount) * 100) / 100, tierLabel: lastTier.label };
}

export function formatUSD(amount: number): string {
  return new Intl.NumberFormat("en-US", { style: "currency", currency: "USD", minimumFractionDigits: 2, maximumFractionDigits: 6 }).format(amount);
}
