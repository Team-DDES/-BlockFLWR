// Setup
const  { Network, Alchemy }  = require('alchemy-sdk');
const { providers, Wallet, utils, Contract, AlchemyProvider, JsonRpcProvider, ethers } = require('ethers');
const {abi} = require('./contracts/abi');
const {bytecode} = require('./contracts/bytecode');
async function start(){
    //https://polygon-mumbai.g.alchemy.com/v2/iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C
    // let provider = new AlchemyProvider("maticmum",'iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C');
    const provider = new ethers.providers.JsonRpcProvider('https://polygon-mumbai.g.alchemy.com/v2/iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C');
    const privateKey = '06bab9bb8b7abd173da46b67eddae1499af0573b92c96b04cccc94d86e8c3965';
    const signer = new ethers.Wallet(privateKey, provider);
    const account = signer.connect(provider);
    
    const myContract = new ethers.ContractFactory(abi, bytecode, signer);
    
    // If your contract requires constructor args, you can specify them here
   const contract = await myContract.deploy();
   await contract.deployed();
   console.log(contract.address);
}
start();
// const settings = {
//     apiKey: "iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C",
//     network: Network.MATIC_MUMBAI,
// };

// const alchemy = new Alchemy(settings);

// async function getData(){
// // Get the latest block
// const latestBlock = await alchemy.core.getBlockNumber();
// alchemy.core
//     .getTokenBalances('0x88085E2EEcCE1077A678E0D04A2755b7D8FFb2a4')
//     .then(console.log);
// console.log(latestBlock);
// }
// getData();
// Get all outbound transfers for a provided address
// alchemy.core
//     .getTokenBalances('0x88085E2EEcCE1077A678E0D04A2755b7D8FFb2a4')
//     .then(console.log);

// // Get all the NFTs owned by an address
// const nfts = alchemy.nft.getNftsForOwner("0xshah.eth");

// // Listen to all new pending transactions
// alchemy.ws.on(
//     { method: "alchemy_pendingTransactions",
//     fromAddress: "0xshah.eth" },
//     (res) => console.log(res)
// );