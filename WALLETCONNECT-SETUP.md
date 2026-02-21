# WalletConnect Setup Guide

The CCTP Exchange frontend needs a **WalletConnect Project ID** so users can connect their crypto wallets (like MetaMask, Rainbow, etc.) to the app.

## How to Get Your Free Project ID

1. Go to **https://cloud.reown.com** (this is WalletConnect's dashboard — they rebranded to "Reown")
2. Click **Sign Up** and create a free account (you can use your Google or GitHub account)
3. Once logged in, click **Create Project**
4. Give it a name like `CCTP Exchange` and select **App** as the type
5. Copy the **Project ID** — it looks like a long string of letters and numbers

## Where to Paste It

1. Open the file: `frontend/.env.local`
   (It's inside your Brad Project → cctp-exchange → frontend folder)

2. Find this line:
   ```
   NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=YOUR_WALLETCONNECT_PROJECT_ID
   ```

3. Replace `YOUR_WALLETCONNECT_PROJECT_ID` with your actual Project ID. For example:
   ```
   NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=abc123def456ghi789
   ```

4. Save the file

5. If the frontend is already running, stop it (close the Terminal window) and double-click **3-START-FRONTEND.command** again

That's it! Wallet connections will now work in your app.
