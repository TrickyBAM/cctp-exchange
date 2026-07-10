const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");

const root = path.resolve(__dirname, "..");
const read = (relativePath) => fs.readFileSync(path.join(root, relativePath), "utf8");

test("the public bridge UI cannot connect a wallet or initiate a bridge", () => {
  const bridgeForm = read("src/components/BridgeForm.tsx");
  const header = read("src/components/Header.tsx");
  const layout = read("src/app/layout.tsx");
  const publicUi = `${bridgeForm}\n${header}\n${layout}`;

  assert.match(bridgeForm, /Transactions disabled — demo only/);
  assert.match(bridgeForm, /<button[\s\S]*?disabled[\s\S]*?>[\s\S]*?Transactions disabled/);
  assert.doesNotMatch(publicUi, /ConnectButton|WalletButton|useAccount|initiateBridge|WagmiProvider/);
});

test("legacy bridge and status hooks fail closed without simulated success", () => {
  const bridgeHook = read("src/hooks/useBridge.ts");
  const statusHook = read("src/hooks/useTransactionStatus.ts");
  const hooks = `${bridgeHook}\n${statusHook}`;

  assert.match(bridgeHook, /DEMO_LOCKED/);
  assert.match(statusHook, /DEMO_LOCKED/);
  assert.doesNotMatch(hooks, /setTimeout|TransferStatus\.COMPLETE|Bridge complete|Ready to bridge/);
});

test("the status page has no fake transaction search", () => {
  const statusPage = read("src/app/status/page.tsx");

  assert.match(statusPage, /no live or simulated transaction-status searches/i);
  assert.doesNotMatch(statusPage, /setTimeout|handleSearch|burn transaction hash|Searching\.\.\./);
});
