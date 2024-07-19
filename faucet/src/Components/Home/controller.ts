//  ====================================================================================================================================
// import readContract from viem/actions
//import the createPublicClient and the trasnport protocol from the view
//import the chains to be used
import { readContract } from "viem/actions";
import { createPublicClient, http } from "viem";
import { sepolia } from "viem/chains";
import { abi } from "./abi";
import { useLayoutEffect, useState } from "react";

const configClient = createPublicClient({
  chain: sepolia,
  transport: http(),
});
// ??========================================================================================================================================================================================================================================================================
import { useWriteContract } from "wagmi";
import { toast } from "react-toastify";

//??========================================================================================================================================================================================================================================================================

export default function useContractMethods() {
  const { writeContractAsync } = useWriteContract();

  const [supply_value, setSupplyValue] = useState<string>("");

  async function _totalSupply() {
    const totalSupplyValue = await readContract(configClient, {
      abi: abi,
      address: "0x2488A7cd65f003c254F19D6F129FC0a917B3183D",
      functionName: "totalSupply",
      args: [],
    });
    return totalSupplyValue;
  }

  async function balanceOf(address: any) {
    const _balance = await readContract(configClient, {
      abi,
      address: "0x2488A7cd65f003c254F19D6F129FC0a917B3183D",
      functionName: "balanceOf",
      args: [address],
    });
    return _balance;
  }

  const _mintToken = (address: any) => {
    writeContractAsync({
      abi,
      address: "0x2488A7cd65f003c254F19D6F129FC0a917B3183D",
      functionName: "recieveTokenDrop",
      args: [address],
      account: address,
    }).catch(() => {
      toast.error("Sorry, you can onmly mint token every 10 mins", { theme: "colored" });
    });
  };

  useLayoutEffect(() => {
    (async () => {
      let _value: any = await _totalSupply();
      setSupplyValue(_value);
    })();
  }, []);

  return { supply_value, balanceOf, _mintToken };
}
