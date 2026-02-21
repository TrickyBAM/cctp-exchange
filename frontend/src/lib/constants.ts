export const CCTP_DOMAINS = { ETHEREUM: 0, ARBITRUM: 3, BASE: 6, XDC: 18 } as const;
export const CHAIN_IDS = { ETHEREUM: 1, BASE: 8453, ARBITRUM: 42161, XDC: 50 } as const;
export const USDC_DECIMALS = 6;
export const FEE_TIERS = [
  { maxAmountUSD: 100, feeBasisPoints: 100, feePercent: 1.0, label: "$0 - $100" },
  { maxAmountUSD: 500, feeBasisPoints: 50, feePercent: 0.5, label: "$100 - $500" },
  { maxAmountUSD: 1_000, feeBasisPoints: 25, feePercent: 0.25, label: "$500 - $1,000" },
  { maxAmountUSD: 10_000, feeBasisPoints: 10, feePercent: 0.1, label: "$1,000 - $10,000" },
  { maxAmountUSD: 100_000, feeBasisPoints: 5, feePercent: 0.05, label: "$10,000 - $100,000" },
  { maxAmountUSD: Infinity, feeBasisPoints: 1, feePercent: 0.01, label: "$100,000+" },
] as const;
