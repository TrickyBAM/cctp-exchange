export const CONTRACT_ADDRESSES = {
  feeManager: (process.env.NEXT_PUBLIC_FEE_MANAGER_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
  treasury: (process.env.NEXT_PUBLIC_TREASURY_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
  bridgeOrchestrator: (process.env.NEXT_PUBLIC_ORCHESTRATOR_ADDRESS || "0x0000000000000000000000000000000000000000") as `0x${string}`,
} as const;

export const BRIDGE_ORCHESTRATOR_ABI = [
  { name: "collectFee", type: "function", stateMutability: "nonpayable", inputs: [{ name: "transferId", type: "bytes32" }, { name: "amount", type: "uint256" }, { name: "sourceDomain", type: "uint32" }], outputs: [] },
  { name: "previewFee", type: "function", stateMutability: "view", inputs: [{ name: "amount", type: "uint256" }], outputs: [{ name: "feeAmount", type: "uint256" }, { name: "netAmount", type: "uint256" }, { name: "feeBasisPoints", type: "uint16" }] },
  { name: "isTransferProcessed", type: "function", stateMutability: "view", inputs: [{ name: "transferId", type: "bytes32" }], outputs: [{ name: "", type: "bool" }] },
] as const;

export const ERC20_ABI = [
  { name: "approve", type: "function", stateMutability: "nonpayable", inputs: [{ name: "spender", type: "address" }, { name: "amount", type: "uint256" }], outputs: [{ name: "", type: "bool" }] },
  { name: "balanceOf", type: "function", stateMutability: "view", inputs: [{ name: "account", type: "address" }], outputs: [{ name: "", type: "uint256" }] },
] as const;
