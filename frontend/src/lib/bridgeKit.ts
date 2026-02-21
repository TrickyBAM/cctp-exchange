import { CCTP_DOMAINS, CHAIN_IDS } from "./constants";

export interface BridgeTransferParams {
  fromChainId: number;
  toChainId: number;
  amount: string;
  recipientAddress: string;
}

export function chainIdToCCTPDomain(chainId: number): number {
  const mapping: Record<number, number> = {
    [CHAIN_IDS.ETHEREUM]: CCTP_DOMAINS.ETHEREUM,
    [CHAIN_IDS.BASE]: CCTP_DOMAINS.BASE,
    [CHAIN_IDS.ARBITRUM]: CCTP_DOMAINS.ARBITRUM,
    [CHAIN_IDS.XDC]: CCTP_DOMAINS.XDC,
  };
  return mapping[chainId] ?? -1;
}

export function getSupportedRoutes() {
  return [
    { from: CHAIN_IDS.ETHEREUM, to: CHAIN_IDS.XDC, label: "Ethereum -> XDC" },
    { from: CHAIN_IDS.BASE, to: CHAIN_IDS.XDC, label: "Base -> XDC" },
    { from: CHAIN_IDS.ARBITRUM, to: CHAIN_IDS.XDC, label: "Arbitrum -> XDC" },
  ];
}
