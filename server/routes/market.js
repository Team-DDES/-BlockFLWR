const express = require('express');
const router = express.Router();
const { insertTask, getTask } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const TaskModel = require('../model/task_model');
const path = require("path")
// 1. child-process모듈의 spawn 취득
const spawn = require('child_process').spawn;
const {Contract, ethers, providers} = require("ethers");
const {token} = require("mysql/lib/protocol/Auth");
require('dotenv').config();
// contract
const provider = new providers.JsonRpcProvider(process.env.RPC_URL);
const signer = provider.getSigner(process.env.METAMASK_EAVLUATOR_ACCOUNT);


// const balanceOf = await contract.balanceOf(signer.address);
// console.log("Your balance is:", balanceOf);
//
// const tokenId = await contract.tokenOfOwnerByIndex(signer.address, 0);
// console.log("Your token ID is:", tokenId);

// market 1. Register organization account's NFT
// should know NFT contract's address
//web3 contract.balanceOf
router.post('/register', async(req, res) => {

    var data = req.body;
    // TODO search NFT contract address from DB
    let contract_address = data.contract_address;
    let user_account = data.user_account;
    console.log(contract_address, user_account);
    // const abi = await provider.getContract()
    const contract = new Contract(ethers.utils.get, contract_address, provider);
    const balanceOf = await contract.balanceOf(signer.address);
    console.log(signer.address + "'s balance : ", balanceOf)
    const tokenId = await contract.tokenOfOwnerByIndex(user_account,balanceOf) // account's token list, ERC721Enumerable.sol

    res.status(200);
    res.send(tokenId)

    // Register to DB

});
module.exports = router;