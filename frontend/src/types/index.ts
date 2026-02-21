export type SourceChainId = 1 | 8453 | 42161;
export type CCTPDomain = 0 | 3 | 6 | 18;

export interface ChainConfig {
  chainId: number;
  name: string;
  shortName: string;
  cctpDomain: CCTPDomain;
  rpcUrl: string;
  explorerUrl: string;
  usdcAddress: `0x${string}`;
}

export interface FeeCalculation {
  amount: number;
  feePercent: number;
  feeAmount: number;
  netAmount: number;
  tierLabel: string;
}

export enum TransferStatus {
  IDLE = "idle",
  APPROVING = "approving",
  BURNING = "burning",
  WAITING_ATTESTATION = "waiting_attestation",
  MINTING = "minting",
  COLLECTING_FEE = "collecting_fee",
  COMPLETE = "complete",
  FAILED = "failed",
}
