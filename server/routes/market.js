const express = require('express');
const router = express.Router();
// const { insertTask, getTask } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const path = require("path")
const {Contract, ethers, providers} = require("ethers");

require('dotenv').config();
// contract
const provider = new providers.JsonRpcProvider(process.env.RPC_URL);
const {nft_abi} = require("../web3/contracts/nft_abi")
CONTRACT_ADDRESS = "0x438b06ab7B23EC536C2Eb292F449B490069D0A64"; //mumbai
const contract = new Contract(CONTRACT_ADDRESS, nft_abi,provider);

// const balanceOf = await contract.balanceOf(signer.address);
// console.log("Your balance is:", balanceOf);
//
// const tokenId = await contract.tokenOfOwnerByIndex(signer.address, 0);
// console.log("Your token ID is:", tokenId);

// market 1. Register organization account's NFT to market
// should know NFT contract's address
// web3 contract.balanceOf
router.post('/register', async(req, res) => {

    var data = req.body;
    let user_account = data.user_account;
    const balanceOf = await contract.balanceOf(user_account);
    console.log(user_account + "'s balance : ", balanceOf)
    const tokenId = await contract.tokenOfOwnerByIndex(user_account,balanceOf) // account's token list, ERC721Enumerable.sol
    console.log(user_account + "'s owned token", tokenId);
    res.status(200);
    res.send(tokenId)

    // Register to DB

});
// get NFT lists of all marketplace
router.get("/", async(req,res)=>{
    console.log("NFT list");

});

// Show detail of NFT
router.get("/detail", async(req,res)=>{
    console.log("NFT detail");
});

//show my NFT list
router.get("/my",async (req,res)=>{
    console.log("my list");
})

// buy NFT
router.post("buy", async(req,res)=>{
    console.log("buy NFT");
})
module.exports = router;