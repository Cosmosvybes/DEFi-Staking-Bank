// global.d.ts
declare module "global" {
  interface Window {
    ethereum?: import("ethers").Eip1193Provider; // Adjust the type according to your needs
  }
}
