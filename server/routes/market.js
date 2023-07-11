const express = require('express');
const router = express.Router();
const { insertMarketNft,getNftTokenIds,deleteMarketNft } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const path = require("path")
const {Contract, ethers, providers, Wallet} = require("ethers");
const axios = require("axios");

require('dotenv').config();

const RPC_URL = "https://polygon-mumbai.g.alchemy.com/v2/e5p2vMdLjoC9WhI26pWlMYrOIgAhANcF"
const provider = new providers.JsonRpcProvider(RPC_URL);
const signer = new Wallet(process.env.METAMASK_EVALUATOR_PRIVATE_KEY,provider);
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
                    res.send(body);
                    res.status(200);
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
                res.status(404);
                res.send(result['data']);
            }
        })
    }catch(err){
        console.log(err)
        res.send(err);
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
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    let metadataList = [];
                    for(let i = 0; i<body.data.length; i++) {
                        tokenId = body.data[i].tokenid;
                        metadata = await readNFTmetadata(tokenId)
                        console.log(tokenId, typeof tokenId)
                        console.log(token_id, typeof token_id)
                        if (tokenId === parseInt(token_id)) {
                            res.send(metadata)
                            res.status(200)
                        }
                    }
                }
            }else{
                res.status(404);
                res.send(result['data']);
            }
        })
    }catch(err){
        console.log(err)
        res.send(err);
    };

});

//show my NFT list
router.get("/my",async (req,res)=>{
    let user_account = req.query.account;
    try{
        await getNftTokenIds(async (result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    let metadataList = [];
                    for(let i = 0; i<body.data.length; i++) {
                        tokenId = body.data[i].tokenid;
                        metadata = await readNFTmetadata(tokenId)
                        if (metadata.owner_address === user_account){
                            metadataList.push(metadata);
                        }
                    }
                    res.status(200);
                    res.send(metadataList);
                }
            }else{
                res.status(404);
                res.send(result['data']);
            }
        })
    }catch(err){
        console.log(err)
        res.send(err);
    };
})

// // buy NFT
router.post("/buy", async(req,res)=>{
    console.log("buy NFT");
    const token_id = req.query.tokenid;
    const buyer_account = req.body.account;
    const functionName = "transferNFT"
    const functionParams = [token_id,buyer_account];
    const transaction = await contract[functionName](...functionParams);
    // sign tx
    const signedTx = await wallet.signTransaction(transaction);
    // send Tx
    const transactionResponse = await provider.sendTransaction(signedTx);

    res.send(transactionResponse)
    // TODO : remove NFT from market table
    try{
        await deleteMarketNft(token_id,(result) => {
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

})
module.exports = router;