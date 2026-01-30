import { useState, useEffect, useCallback, useMemo } from 'react';
// Assuming these are singleton instances or created once
const baseAdapter = new BaseWalletAdapter();
const stacksAdapter = new StacksWalletAdapter();

export function useWallets() {
  const [baseAddress, setBaseAddress] = useState<string | null>(null);
  const [stacksAddress, setStacksAddress] = useState<string | null>(null);
  const [isConnecting, setIsConnecting] = useState(false);

  // --- Base Logic ---
  const connectBase = useCallback(async () => {
    setIsConnecting(true);
    try {
      const { address } = await baseAdapter.connect();
      setBaseAddress(address);
      localStorage.setItem('wallet_connected_base', 'true');
    } catch (e) {
      console.error("Base Connect Error", e);
    } finally {
      setIsConnecting(false);
    }
  }, []);

  // --- Stacks Logic ---
  const connectStacks = useCallback(async () => {
    try {
      const origin = typeof window !== 'undefined' ? window.location.origin : '';
      const address = await stacksAdapter.connect("DApp", `${origin}/icon.png`);
      setStacksAddress(address);
    } catch (e) {
      console.error("Stacks Connect Error", e);
    }
  }, []);

  const disconnectAll = useCallback(() => {
    stacksAdapter.disconnect();
    // Add baseAdapter disconnect if supported
    setBaseAddress(null);
    setStacksAddress(null);
    localStorage.removeItem('wallet_connected_base');
  }, []);

  // --- Auto-reconnect & Listeners ---
  useEffect(() => {
    // Check if user was previously connected to Base
    if (localStorage.getItem('wallet_connected_base')) {
      baseAdapter.getAddress().then(setBaseAddress).catch(() => {});
    }

    // Example listener (check your specific adapter API for 'accountChanged')
    const handleAccountChange = (accounts: string[]) => {
       setBaseAddress(accounts[0] || null);
    };

    // cleanup
    return () => {
      // baseAdapter.off('accountsChanged', handleAccountChange);
    };
  }, []);

  return useMemo(() => ({
    baseAddress,
    stacksAddress,
    connectBase,
    connectStacks,
    disconnectAll,
    isConnecting,
    baseAdapter,
    stacksAdapter
  }), [baseAddress, stacksAddress, connectBase, connectStacks, disconnectAll, isConnecting]);
}
