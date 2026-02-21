"use client";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export function WalletButton() {
  return (
    <ConnectButton.Custom>
      {({ account, chain, openConnectModal, openChainModal, mounted }) => {
        const connected = mounted && account && chain;
        return (
          <div {...(!mounted && { style: { opacity: 0, pointerEvents: "none" as const } })}>
            {!connected ? (
              <button onClick={openConnectModal} className="w-full rounded-xl bg-blue-600 px-6 py-4 text-lg font-semibold text-white hover:bg-blue-500 active:scale-[0.98]">Connect Wallet</button>
            ) : chain.unsupported ? (
              <button onClick={openChainModal} className="w-full rounded-xl bg-red-600 px-6 py-4 text-lg font-semibold text-white hover:bg-red-500">Wrong Network</button>
            ) : null}
          </div>
        );
      }}
    </ConnectButton.Custom>
  );
}
