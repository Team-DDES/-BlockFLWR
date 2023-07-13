// Setup
const  { Network, Alchemy }  = require('alchemy-sdk');
const { providers, Wallet, utils, Contract, AlchemyProvider, JsonRpcProvider, ethers } = require('ethers');
const {abi} = require('./contracts/abi');
const {bytecode} = require('./contracts/bytecode');
const {nft_abi} = require('./contracts/nft_abi');
const {nft_bytecode} = require('./contracts/nft_bytecode');
const {updateTask} = require('../database/mysql');
const path = require("path")
const spawn = require('child_process').spawn;
//var exec = require('child_process').exec, child;

var port = 8083;

function createTaskContract(taskId){
    //https://polygon-mumbai.g.alchemy.com/v2/iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C
    // let provider = new AlchemyProvider("maticmum",'iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C');
    const provider = new ethers.providers.JsonRpcProvider('https://polygon-mumbai.g.alchemy.com/v2/iWAnKUG94_jJyWY74c6CHYXAU_FuEf_C');
    //const provider = new ethers.providers.JsonRpcProvider('https://rpc.public.zkevm-test.net');
    const privateKey = '06bab9bb8b7abd173da46b67eddae1499af0573b92c96b04cccc94d86e8c3965';
    const signer = new ethers.Wallet(privateKey, provider);
    const account = signer.connect(provider);
    const myCrowdContract = new ethers.ContractFactory(abi, bytecode, signer);
    const nftContract = new ethers.ContractFactory(nft_abi, nft_bytecode, signer);
    const _taskId = taskId;
    const nftContractAddress = '0x26358547718cA8c272C285a1d3161131570F480B';
    
    myCrowdContract.deploy().then((contract)=>{
    var __taskId = _taskId
    var __nftContractAddress = nftContractAddress;
    var __port = port++;
    console.log(contract.address);
    var data = {taskId:__taskId, taskContractAddress:contract.address, taskStatusCode:1, taskPort:__port}
    updateTask(data,(result)=>{console.log(result)})
    
    runServer(contract.address,__nftContractAddress,1,__port);
   }).catch((err)=>{
    console.log(err);
   })
   console.log("finsih"+taskId)
}
//createTaskContract();
module.exports = {
    createTaskContract
}

function runServer(taskContractAddress,nftContractAddress,round, port){
    // 2. spawn을 통해 "python 파이썬파일.py" 명령어 실행
    const result = spawn('/usr/bin/python3', [path.join(__dirname, '..', '..', '/examples/quickstart_pytorch_ethereum/server.py'),'0.0.0.0:'+port,round,taskContractAddress,nftContractAddress,"Mnist"]);
    //3. stdout의 'data'이벤트리스너로 실행결과를 받는다.
    result.stdout.on('data', function(data) {
        console.log("get Data");
        console.log(data.toString());
    });

    // 4. 에러 발생 시, stderr의 'data'이벤트리스너로 실행결과를 받는다.
    result.stderr.on('data', function(data) {
        console.log("get error");
        console.log(data.toString());
    });
    // var child = new exec('/usr/bin/python3 /media/hdd1/es_workspace/D-DES/examples/quickstart_pytorch_ethereum/server.py'+' 0.0.0.0:'+port+' 2 '+taskContractAddress+' '+nftContractAddress+' Mnist');
    // // Add the child process to the list for tracking
    // // Listen for any response:
    // console.log('/usr/bin/python3 /media/hdd1/es_workspace/D-DES/examples/quickstart_pytorch_ethereum/server.py'+' 0.0.0.0:'+port+' 2 '+taskContractAddress+' '+nftContractAddress+' Mnist')
    // child.stdout.on('data', function (data) {
    //     console.log(child.pid, data);
    // });

    // // Listen for any errors:
    // child.stderr.on('data', function (data) {
    //     console.log(child.pid, data);
    // }); 

    // // Listen if the process closed
    // child.on('close', function(exit_code) {
    //     console.log('Closed before stop: Closing code: ', exit_code);
    // });
}
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