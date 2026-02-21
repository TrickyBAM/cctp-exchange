"use client";
import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { mainnet, base, arbitrum } from "wagmi/chains";
import { xdcNetwork } from "./chains";

export const wagmiConfig = getDefaultConfig({
  appName: "CCTP.Valid",
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || "YOUR_PROJECT_ID",
  chains: [mainnet, base, arbitrum, xdcNetwork],
  ssr: true,
});
