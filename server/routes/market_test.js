const express = require('express');
const router = express.Router();
// const { insertMarketNft } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const path = require("path")
const {Contract, ethers, providers, Wallet} = require("ethers");
const axios = require("axios");

require('dotenv').config({ path: "../.env"});

const RPC_URL = "https://polygon-mumbai.g.alchemy.com/v2/e5p2vMdLjoC9WhI26pWlMYrOIgAhANcF"
const provider = new providers.JsonRpcProvider(RPC_URL);
// const signer = new Wallet(METAMASK_EVALUATOR_PRIVATE_KEY,provider);
const {nft_abi} = require("../web3/contracts/nft_abi")
CONTRACT_ADDRESS = "0xe62F3C05D076ddd787A68a903DdAa0B65FAe5e58"; //mumbai

const contract = new Contract(CONTRACT_ADDRESS, nft_abi,provider);
// const ipfsclient = create({url:"http://127.0.0.1:5001"})

// // NFT metadata reading function
async function readNFTmetadata (tokenId) {
    // 1. get tokenUri using tokenId
    let tokenList = [];
    const tokenUri = await contract.getTokenURI(tokenId);
   const result = await axios.get(tokenUri);
    tokenList.push(result.data)
    console.log(tokenList)
}
//
readNFTmetadata(1);
// // market 1. Register organization account's NFT to market
// // should know NFT contract's address
// // web3 contract.balanceOf
// router.post('/register', async(req, res) => {
//     console.log("register start");
//     let data = req.body;
//     let user_account = data.user_account;
//     let price = data.price;
//     // console.log(typeof(user_account))
//     const balance = await contract.balanceOf(user_account);
//     console.log(user_account + "'s balance : ", balance)
//     // let tokenidList = [];
//     task = {};
//     for (let i =0; i<balance; i++){
//         const tokenId = await contract.tokenOfOwnerByIndex(user_account,i) // account's token list, ERC721Enumerable.sol
//         console.log(user_account + "'s owned token id", parseInt(tokenId))
//         task.tokenid = parseInt(tokenId);
//         task.price = price;
//         console.log(task)
//         try{
//         await insertMarketNft(task,(result)=>{
//             if(result['type']){
//                 var data = result['data'];
//                 if(data == null){
//                     var body = failMessage(result['data'],'task not found',404);
//                     res.send(body);
//                     res.status(200);
//                 }else{
//                     var body = successMessage(result['data']);
//                     console.log(body)
//                     // res.send(body);
//                 }
//             }else{
//                 res.status(404);
//                 res.send(result['data']);
//             }
//         })
//     }catch(err){
//         console.log(err)
//         res.send(err);
//     }
//     }
//
//     res.send("success")
//     res.status(200)
//
// });
// // get NFT lists of all marketplace
// router.get("/", async(req,res)=>{
//     let metadata = await readNFTmetadata("1");
//     res.send(metadata);
//     res.status(200);
//
//
// });
// //
// // // Show detail of NFT
// // router.get("/detail", async(req,res)=>{
// //     console.log("NFT detail");
// // });
// //
// // //show my NFT list
// // router.get("/my",async (req,res)=>{
// //     console.log("my list");
// // })
// //
// // // buy NFT
// // router.post("buy", async(req,res)=>{
// //     console.log("buy NFT");
// // })
// module.exports = router;