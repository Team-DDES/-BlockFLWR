// Setup
const  { Network, Alchemy }  = require('alchemy-sdk');
const { providers, Wallet, utils, Contract, AlchemyProvider, JsonRpcProvider, ethers } = require('ethers');
const {abi} = require('./contracts/abi');
const {bytecode} = require('./contracts/bytecode');
const {updateTask} = require('../database/mysql');
const path = require("path")
const spawn = require('child_process').spawn;

var port = 8082;
var providerPath = 'https://rpc.public.zkevm-test.net';
var privateKey = '06bab9bb8b7abd173da46b67eddae1499af0573b92c96b04cccc94d86e8c3965';
var nftContractAddress = '0xe62F3C05D076ddd787A68a903DdAa0B65FAe5e58';
const pythonPath = '/usr/bin/python3';
const serverPyPath = 'examples/quickstart_pytorch_ethereum/server.py';

function createTaskContract(taskId){
    const provider = new ethers.providers.JsonRpcProvider(providerPath);
    const signer = new ethers.Wallet(privateKey, provider);
    const myCrowdContract = new ethers.ContractFactory(abi, bytecode, signer);
    const _taskId = taskId;
    
    myCrowdContract.deploy().then((contract)=>{
    var __taskId = _taskId
    var __nftContractAddress = nftContractAddress;
    var __port = port++;

    var data = {taskId:__taskId, taskContractAddress:contract.address, taskStatusCode:1, taskPort:__port}
    updateTask(data,(result)=>{})

    runServer(contract.address,__nftContractAddress,1,__port);

   }).catch((err)=>{
    console.log(err);
   })
}

module.exports = {
    createTaskContract
}

function runServer(taskContractAddress,nftContractAddress,round, port){
    const result = spawn(pythonPath, [path.join(__dirname, '..', '..', serverPyPath),'0.0.0.0:'+port,round,taskContractAddress,nftContractAddress,"Mnist"]);
    result.stdout.on('data', function(data) {
        console.log("get Data");
        console.log(data.toString());
    });
    result.stderr.on('data', function(data) {
        console.log("get error");
        console.log(data.toString());
    });

}
