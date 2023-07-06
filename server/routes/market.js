const express = require('express');
const router = express.Router();
const { insertMarketNft,getNftTokenIds } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const path = require("path")
const {Contract, ethers, providers, Wallet} = require("ethers");
const axios = require("axios");

require('dotenv').config();

const nftContractAddress = "0xe62F3C05D076ddd787A68a903DdAa0B65FAe5e58"; //mumbai
const provider = new providers.JsonRpcProvider(process.env.RPC_URL);
const signer = new Wallet(process.env.METAMASK_EVALUATOR_PRIVATE_KEY,provider);
const {nft_abi} = require("../web3/contracts/nft_abi")
const contract = new Contract(nftContractAddress, nft_abi,provider);
const contractWithSigner = contract.connect(signer);
// const ipfsclient = create({url:"http://127.0.0.1:5001"})

// // NFT metadata reading function
async function readNFTmetadata (tokenId) {
    // 1. get tokenUri using tokenId
    const tokenUri = await contract.getTokenURI(tokenId);
   const result = await axios.get(tokenUri);
   return result.data
}
// Emit approval when NFT registration : FrontEnd
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
                            res.status(200);
                            res.send(metadata);
                            break;
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

// buy NFT : transferFrom, (msg.sender : server)
// TODO : Token Transfer
router.post("buy", async(req,res)=>{
    console.log("buy NFT");
    // exec approve NEED: tokenId, approved address
    let tokenId = req.body.tokenId;
    let owner_address = req.body.owner;
    let receiver_address = req.body.receiver;
    // let transferResult = await contract.transferFrom(owner_address,receiver_address,tokenId);

    // 1. check receiver's balance is matched with DB's price
    // 2. Transfer receiver's coin(testcoin) to owner's wallet

    // send signed Tx
    // Build TX
    const functionParams = [owner_address,receiver_address,tokenId];
    const functionName = "transferFrom";
    const transaction = await contractWithSigner[functionName](...functionParams);

    // Sign Tx
    const signedTransaction = await signer.signTransaction(transaction);
    const transactionRes = await provider.sendTransaction(signedTransaction);

    //res
    console.log(transactionRes);
})
module.exports = router;