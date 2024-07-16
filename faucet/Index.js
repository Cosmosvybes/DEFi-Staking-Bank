const { Web3 } = require("web3");
const { useContractCredentials } = require("./credentials");
const web3 = new Web3("http://localhost:8545");
const { abi, contractAddress } = useContractCredentials();
const contract = new web3.eth.Contract(abi, contractAddress);

async function getTokenName() {
  contract.methods
    .getName()
    .call()
    .then((result) => console.log(result.toString()));
}
// getTokenName();

function transferToken() {
  contract.methods
    .transfer("0xa0ee7a142d267c1f36714e4a8f75612f20a79720", 200)
    .send({ from: "0x90F79bf6EB2c4f870365E785982E1f101E93b906" })
    .then((result) => {
      if (result.transactionHash) {
        return getBalance("0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65");
      }
    })
    .catch((err) => {
      console.log(err);
    });
}

transferToken();
function getBalance(address) {
  contract.methods
    .balanceOf(address)
    .call()
    .then((result) => console.log(result.toString()));
}

function approveSpender() {
  contract.methods
    .approve("0x70997970C51812dc3A010C7d01b50e0d17dc79C8", "2000000")
    .send({ from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" })
    .then((result) => console.log(result));
}
// approveSpender()
function checkSpenderAllowance() {
  contract.methods
    .allowance("0x70997970C51812dc3A010C7d01b50e0d17dc79C8")
    .call()
    .then((response) => console.log(response.toString()));
}

// checkSpenderAllowance();

async function buyToken() {
  await contract.methods
    ._purchaseToken("0xa0ee7a142d267c1f36714e4a8f75612f20a79720")
    .send({
      from: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      value: web3.utils.toWei("0.005", "ether"),
    })
    .then((result) => console.log(result));
}
// buyToken("0xa0ee7a142d267c1f36714e4a8f75612f20a79720");
// getBalance("0xa0ee7a142d267c1f36714e4a8f75612f20a79720");
