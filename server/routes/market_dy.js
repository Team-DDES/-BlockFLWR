const express = require('express');
const router = express.Router();
const { insertMarketNft,getNftTokenIds } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const path = require("path")
const {Contract, ethers, providers, Wallet} = require("ethers");
const axios = require("axios");

require('dotenv').config({ path: "../.env"});

const RPC_URL = "https://polygon-mumbai.g.alchemy.com/v2/e5p2vMdLjoC9WhI26pWlMYrOIgAhANcF"
const provider = new providers.JsonRpcProvider(RPC_URL);
// const signer = new Wallet(METAMASK_EVALUATOR_PRIVATE_KEY,provider);
const {nft_abi} = require("../web3/contracts/nft_abi")
CONTRACT_ADDRESS = "0x26358547718cA8c272C285a1d3161131570F480B"; //mumbai

const contract = new Contract(CONTRACT_ADDRESS, nft_abi,provider);
// const ipfsclient = create({url:"http://127.0.0.1:5001"})

// // NFT metadata reading function
async function readNFTmetadata (tokenId) {
    // 1. get tokenUri using tokenId
    const tokenUri = await contract.getTokenURI(tokenId);
   const result = await axios.get(tokenUri);
   return result.data
}

router.post('/register', async(req, res) => {
    console.log("register start");
    let data = req.body;
    let user_account = data.user_account;
    let price = data.price;
    // console.log(typeof(user_account))
    const balance = await contract.balanceOf(user_account);
    console.log(user_account + "'s balance : ", balance)
    // let tokenidList = [];
    task = {};
    for (let i =0; i<balance; i++){
        const tokenId = await contract.tokenOfOwnerByIndex(user_account,i) // account's token list, ERC721Enumerable.sol
        console.log(user_account + "'s owned token id", parseInt(tokenId))
        task.tokenid = parseInt(tokenId);
        task.price = price;
        console.log(task)
        try{
        await insertMarketNft(task,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    console.log(body)
                    // res.send(body);
                }
            }else{
                res.status(404);
                res.send(result['data']);
            }
        })
    }catch(err){
        console.log(err)
        res.send(err);
    }
    }

    res.send("success")
    res.status(200)

});
// get NFT lists of all marketplace
router.get("/", async(req,res)=>{
    // 1. search full token id  list from DB
    // 2. get metadata list using readNFTmetadata(tokenId) function
    // const tokenIdList = [];
    // let metadata = await readNFTmetadata("1");
    // let tokenList = [];
    try{
        await getNftTokenIds(async (result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    // res.send(body);
                    // res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    let metadataList = [];
                    for(let i = 0; i<body.data.length; i++){
                        tokenId = body.data[i].tokenid;
                        metadata = await readNFTmetadata(tokenId)
                        metadataList.push(metadata)
                        console.log(metadataList)
                    }
                    res.send(metadataList);
                    res.status(200);
                }
            }else{
                // res.status(404);
                // res.send(result['data']);
            }
        })
    }catch(err){
        console.log(err)
        // res.send(err);
    };


});

// Show detail of NFT
router.get("/detail", async(req,res)=>{
    const token_id = req.query.tokenid;
    try{
        await getNftTokenIds(async (result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    // res.send(body);
                    // res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    let metadataList = [];
                    for(let i = 0; i<body.data.length; i++) {
                        tokenId = body.data[i].tokenid;
                        metadata = await readNFTmetadata(tokenId)
                        if (tokenId === token_id) {
                            res.send(metadata)
                            res.status(200)
                        }
                    }
                }
            }else{
                // res.status(404);
                // res.send(result['data']);
            }
        })
    }catch(err){
        console.log(err)
        // res.send(err);
    };

});
//
// //show my NFT list
// router.get("/my",async (req,res)=>{
//     console.log("my list");
// })
//
// // buy NFT
// router.post("buy", async(req,res)=>{
//     console.log("buy NFT");
// })
module.exports = router;