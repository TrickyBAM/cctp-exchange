"use client";
import { defineChain } from "viem";
import { mainnet, base, arbitrum } from "viem/chains";
import type { ChainConfig } from "@/types";
import { CCTP_DOMAINS, CHAIN_IDS } from "@/lib/constants";

export const xdcNetwork = defineChain({
  id: 50,
  name: "XDC Network",
  nativeCurrency: { name: "XDC", symbol: "XDC", decimals: 18 },
  rpcUrls: { default: { http: ["https://rpc.xdc.network"] } },
  blockExplorers: { default: { name: "XDCScan", url: "https://xdcscan.com" } },
});

export const SOURCE_CHAINS: Record<number, ChainConfig> = {
  [CHAIN_IDS.ETHEREUM]: { chainId: 1, name: "Ethereum", shortName: "ETH", cctpDomain: CCTP_DOMAINS.ETHEREUM, rpcUrl: "https://eth.llamarpc.com", explorerUrl: "https://etherscan.io", usdcAddress: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48" },
  [CHAIN_IDS.BASE]: { chainId: 8453, name: "Base", shortName: "BASE", cctpDomain: CCTP_DOMAINS.BASE, rpcUrl: "https://mainnet.base.org", explorerUrl: "https://basescan.org", usdcAddress: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913" },
  [CHAIN_IDS.ARBITRUM]: { chainId: 42161, name: "Arbitrum", shortName: "ARB", cctpDomain: CCTP_DOMAINS.ARBITRUM, rpcUrl: "https://arb1.arbitrum.io/rpc", explorerUrl: "https://arbiscan.io", usdcAddress: "0xaf88d065e77c8cC2239327C5EDb3A432268e5831" },
};

export function getSourceChains(): ChainConfig[] { return Object.values(SOURCE_CHAINS); }
export function getWagmiChains() { return [mainnet, base, arbitrum, xdcNetwork] as const; }
