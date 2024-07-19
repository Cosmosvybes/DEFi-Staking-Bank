import { WagmiProvider } from "wagmi";
import walletConnectController from "./wallet";

export function Web3ModalProvider({ children }: any) {
  const { config, QueryClient, QueryClientProvider } =
    walletConnectController();

  const queryClient = new QueryClient();
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    </WagmiProvider>
  );
}
