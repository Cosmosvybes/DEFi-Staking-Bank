import { createWeb3Modal } from "@web3modal/wagmi/react";
import { defaultWagmiConfig } from "@web3modal/wagmi/react/config";

import { arbitrum, mainnet, sepolia } from "wagmi/chains";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const projectId = "1028e6cd70d9e451d11275c9cda97e19";

// 2. Create wagmiConfig
const metadata = {
  name: "Web3Modal",
  description: "Mills token",
  url: "https://mills-token-app.vercel.app", // origin must match your domain & subdomain
  icons: ["https://avatars.githubusercontent.com/u/37784886"],
};

const chains = [mainnet, arbitrum, sepolia] as const;
const config = defaultWagmiConfig({
  chains,
  projectId,
  metadata,
  enableCoinbase: true,
  enableWalletConnect: true,
  enableInjected: true,
});

// 3. Create modal
createWeb3Modal({
  wagmiConfig: config,
  projectId,
  enableAnalytics: true, // Optional - defaults to your Cloud configuration
  enableOnramp: true, // Optional - false as default
});

export default function walletConnectController() {
  return {
    config,
    QueryClientProvider,
    QueryClient,
  };
}
