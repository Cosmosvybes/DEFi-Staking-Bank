function useContractCredentials() {
  const abi = [
    {
      type: "constructor",
      inputs: [
        { name: "_address", type: "address", internalType: "address" },
        { name: "_name", type: "string", internalType: "string" },
        { name: "_symbol", type: "string", internalType: "string" },
        { name: "_decimal", type: "uint8", internalType: "uint8" },
      ],
      stateMutability: "nonpayable",
    },
    { type: "receive", stateMutability: "payable" },
    {
      type: "function",
      name: "_changeOwner",
      inputs: [
        { name: "_newOwner", type: "address", internalType: "address payable" },
      ],
      outputs: [{ name: "", type: "bool", internalType: "bool" }],
      stateMutability: "nonpayable",
    },
    {
      type: "function",
      name: "_getOwner",
      inputs: [],
      outputs: [{ name: "_owner", type: "address", internalType: "address" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "_purchaseToken",
      inputs: [
        { name: "_recepient", type: "address", internalType: "address" },
      ],
      outputs: [
        { name: "truthyFalsy", type: "bool", internalType: "bool" },
        { name: "response", type: "bytes", internalType: "bytes" },
      ],
      stateMutability: "payable",
    },
    {
      type: "function",
      name: "_totalSupply",
      inputs: [],
      outputs: [{ name: "", type: "uint256", internalType: "uint256" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "allowance",
      inputs: [{ name: "_spender", type: "address", internalType: "address" }],
      outputs: [
        { name: "remaining", type: "uint256", internalType: "uint256" },
      ],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "approve",
      inputs: [
        { name: "_spender", type: "address", internalType: "address" },
        { name: "_amount", type: "uint256", internalType: "uint256" },
      ],
      outputs: [{ name: "", type: "bool", internalType: "bool" }],
      stateMutability: "nonpayable",
    },
    {
      type: "function",
      name: "balanceOf",
      inputs: [{ name: "_address", type: "address", internalType: "address" }],
      outputs: [{ name: "balance", type: "uint256", internalType: "uint256" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "decimals",
      inputs: [],
      outputs: [{ name: "", type: "uint8", internalType: "uint8" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "getName",
      inputs: [],
      outputs: [{ name: "", type: "string", internalType: "string" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "getSymbol",
      inputs: [],
      outputs: [{ name: "", type: "string", internalType: "string" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "name",
      inputs: [],
      outputs: [{ name: "", type: "string", internalType: "string" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "switchOwner",
      inputs: [
        { name: "_newOwner", type: "address", internalType: "address payable" },
      ],
      outputs: [{ name: "success", type: "bool", internalType: "bool" }],
      stateMutability: "nonpayable",
    },
    {
      type: "function",
      name: "symbol",
      inputs: [],
      outputs: [{ name: "", type: "string", internalType: "string" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "totalSupply",
      inputs: [],
      outputs: [{ name: "", type: "uint256", internalType: "uint256" }],
      stateMutability: "view",
    },
    {
      type: "function",
      name: "transfer",
      inputs: [
        { name: "_to", type: "address", internalType: "address" },
        { name: "_amount", type: "uint256", internalType: "uint256" },
      ],
      outputs: [{ name: "", type: "bool", internalType: "bool" }],
      stateMutability: "nonpayable",
    },
    {
      type: "function",
      name: "transferFrom",
      inputs: [
        { name: "_spender", type: "address", internalType: "address" },
        { name: "_to", type: "address", internalType: "address" },
        { name: "_amount", type: "uint256", internalType: "uint256" },
      ],
      outputs: [{ name: "", type: "bool", internalType: "bool" }],
      stateMutability: "nonpayable",
    },
    {
      type: "function",
      name: "unLock",
      inputs: [],
      outputs: [{ name: "", type: "bool", internalType: "bool" }],
      stateMutability: "nonpayable",
    },
    {
      type: "event",
      name: "Approval",
      inputs: [
        {
          name: "_owner",
          type: "address",
          indexed: true,
          internalType: "address",
        },
        {
          name: "_spender",
          type: "address",
          indexed: false,
          internalType: "address",
        },
        {
          name: "_amount",
          type: "uint256",
          indexed: false,
          internalType: "uint256",
        },
      ],
      anonymous: false,
    },
    {
      type: "event",
      name: "Transfer",
      inputs: [
        {
          name: "_from",
          type: "address",
          indexed: true,
          internalType: "address",
        },
        {
          name: "_to",
          type: "address",
          indexed: true,
          internalType: "address",
        },
        {
          name: "_amount",
          type: "uint256",
          indexed: false,
          internalType: "uint256",
        },
      ],
      anonymous: false,
    },
    { type: "error", name: "InvalidAddress", inputs: [] },
  ];
  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  return {
    abi,
    contractAddress,
  };
}
module.exports = { useContractCredentials };
