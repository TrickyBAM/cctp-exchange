# CCTP Exchange Agent Notes

## Project
CCTP Exchange, rebranded in recent commits as CCTP.Valid, is a cross-chain USDC bridge focused on moving native USDC to the XDC Network through Circle CCTP V2. The repo contains Solidity contracts for fees, treasury, access control, and bridge orchestration plus a nested Next.js frontend for wallet connection, bridge entry, fee preview, and transaction status.

## Stack
- Solidity contracts built with Foundry under `contracts`.
- Next.js 14 App Router frontend under `frontend`.
- React 18, TypeScript, Tailwind CSS, RainbowKit, wagmi, viem, TanStack Query, and WalletConnect/Reown.
- npm is the frontend package manager.

## Gotchas And Quirks
- The app is split across `contracts` and `frontend`; run frontend commands from `frontend`, not the repo root.
- `frontend/.env.local` is currently tracked and contains placeholder public values. Do not commit real wallet, RPC, or contract secrets there.
- Contract addresses default to the zero address when env vars are missing, so a UI can render while still being nonfunctional.
- Wallet connection needs a WalletConnect/Reown project ID; `WALLETCONNECT-SETUP.md` explains the manual setup.
- The helper scripts are macOS `.command` files, so Windows agents should use the underlying npm/foundry commands directly.

## How Brian Works
- Brian describes what he wants in plain English. Do the actual implementation, testing, and GitHub work for him.
- Do not hand Brian snippets to paste or ask him to read code. Make the change, verify it, and summarize in plain English.
- Read the README, recent commits, `AGENTS.md`, and `CLAUDE.md` before assuming project context.
- Ask only for real product direction, source-of-truth choices, or destructive/live-production actions. For normal branch work, proceed.
- Prefer the existing stack and npm. Do not add new frameworks or major libraries without a clear reason.
