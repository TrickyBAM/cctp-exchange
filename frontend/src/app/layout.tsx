import type { Metadata } from "next";
import "./globals.css";
import { Providers } from "@/components/Providers";
import { Header } from "@/components/Header";

export const metadata: Metadata = {
  title: "CCTP.Exchange | USDC Bridge to XDC",
  description: "Bridge USDC from Ethereum, Base, and Arbitrum to XDC Network using Circle CCTP V2.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="font-sans antialiased">
        <Providers>
          <Header />
          <main className="min-h-[calc(100vh-73px)]">{children}</main>
        </Providers>
      </body>
    </html>
  );
}
