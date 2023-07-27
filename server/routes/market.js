const express = require('express');
const router = express.Router();
const { insertMarketNft,getNftTokenIds,deleteMarketNft } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const path = require("path")
const {Contract, ethers, providers, Wallet} = require("ethers");
const axios = require("axios");
const MarketModel = require('../model/market_model');

require('dotenv').config();

const RPC_URL = "https://polygon-mumbai.g.alchemy.com/v2/e5p2vMdLjoC9WhI26pWlMYrOIgAhANcF"
const provider = new providers.JsonRpcProvider(RPC_URL);
const wallet = new Wallet(process.env.METAMASK_EVALUATOR_PRIVATE_KEY,provider);
const signer = wallet.connect(provider);
const {nft_abi} = require("../web3/contracts/nft_abi")
const TaskModel = require("../model/task_model");
CONTRACT_ADDRESS = "0x26358547718cA8c272C285a1d3161131570F480B"; //mumbai

const contract = new Contract(CONTRACT_ADDRESS, nft_abi,signer);
// const ipfsclient = create({url:"http://127.0.0.1:5001"})

// // NFT metadata reading function
async function readNFTmetadata (tokenId) {
    // 1. get tokenUri using tokenId
   const tokenUri = await contract.getTokenURI(tokenId);
    try{
        const result = await axios.get(tokenUri);
        console.log("readMetadata",result.data)
        return result.data
    }catch(e){
        return null;
    }
}

router.post('/register', async(req, res) => {
    console.log("register start");
    const token_id = req.query.tokenid;
    let data = req.body;
    let user_account = data.user_account;
    let price = data.price;
    // console.log(typeof(user_account))
    const balance = await contract.balanceOf(user_account);
    console.log(user_account + "'s balance : ", balance)
    // let tokenidList = [];
    task = {};
    task.tokenid = parseInt(token_id);
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
    // for (let i =0; i<balance; i++){
    //     const tokenId = await contract.tokenOfOwnerByIndex(user_account,i) // account's token list, ERC721Enumerable.sol
    //     console.log(user_account + "'s owned token id", parseInt(tokenId))
    //     task.tokenid = parseInt(tokenId);
    //     task.price = price;
    //     console.log(task)
    //     try{
    //     await insertMarketNft(task,(result)=>{
    //         if(result['type']){
    //             var data = result['data'];
    //             if(data == null){
    //                 var body = failMessage(result['data'],'task not found',404);
    //                 res.send(body);
    //                 res.status(200);
    //             }else{
    //                 var body = successMessage(result['data']);
    //                 console.log(body)
    //                 // res.send(body);
    //             }
    //         }else{
    //             res.status(404);
    //             res.send(result['data']);
    //         }
    //     })
    // }catch(err){
    //     console.log(err)
    //     res.send(err);
    // }
    // }

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
                    // console.log(body.data);
                    for(let i = 0; i<body.data.length; i++){
                        tokenId = body.data[i].tokenid;
                        metadata = await readNFTmetadata(tokenId)
                        metadata.tokenId = tokenId
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
    try{
        let user_account = req.query.account;
        let tokenList = [];
        const balance = await contract.balanceOf(user_account);
        // console.log(balance);
        for (let i = 0; i < balance; i++) {
            let tokenId = await contract.tokenOfOwnerByIndex(user_account, i);
            tokenId = tokenId * 10 ** 18;
            tokenList.push(tokenId);
        }
        // console.log(tokenList);
        if(balance === 0){
            res.status(404)
            res.send({"msg":"No NFT"})
        }else{
            let metadataList = [];
        for (let j = 0; j < tokenList.length; j++) {
            // console.log("gogo")
            const metadata = await readNFTmetadata(tokenList[j] / (10 ** 18));
            // console.log(metadata)
            if (metadata !== null){
                metadata.tokenId = tokenList[j] / (10 ** 18);
                metadataList.push(metadata);
            }
        }
        if (metadataList.length > 0) {
            res.status(200);
            res.send(metadataList);
        } else {
            res.status(200);
            res.send({"msg": "no token"})
        }
        }
    }catch(e){
        res.status(404);
        res.send({"msg":"someThing gone wrong"});
    }
    // try{
    //     const totalSupply =
    //     await getNftTokenIds(async (result)=>{
    //         if(result['type']){
    //             var data = result['data'];
    //             if(data == null){
    //                 var body = failMessage(result['data'],'task not found',404);
    //                 res.send(body);
    //                 res.status(200);
    //             }else{
    //                 var body = successMessage(result['data']);
    //                 let metadataList = [];
    //                 for(let i = 0; i<body.data.length; i++) {
    //                     tokenId = body.data[i].tokenid;
    //                     metadata = await readNFTmetadata(tokenId)
    //                     metadata.tokenId=tokenId;
    //                     const owner_address = await contract.ownerOf(tokenId);
    //                     console.log(owner_address)
    //                     if (owner_address === user_account){
    //                         metadataList.push(metadata);
    //                     }
    //                 }
    //                 res.status(200);
    //                 res.send(metadataList);
    //             }
    //         }else{
    //             res.status(404);
    //             res.send(result['data']);
    //         }
    //     })
    // }catch(err){
    //     console.log(err)
    //     res.send(err);
    // };
})

// // buy NFT
router.post("/buy", async(req,res)=>{
    console.log("buy NFT");
    const token_id = req.query.tokenid;
    const buyer_account = req.body.account;
    const paddedAddr = ethers.utils.getAddress(buyer_account);
    const tokenId = ethers.BigNumber.from(token_id);
    const functionParams = [tokenId,paddedAddr];
    const transaction = await contract.transferNFT(...functionParams);
    // TODO : Check response , remix + postman
    console.log(transaction);
    // res.status(200);
    // res.send(transaction);
    // TODO : remove NFT from market table

    const data = {"tokenid":token_id,"price":2};
    const task = new MarketModel(data);

    try{
        await deleteMarketNft(task,(result) => {
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