import {useEffect, useState} from "react";
import {Typography,Box,Button} from "@mui/material";
import ExampleImg from "../images/example_org_1.png"
import axios from "axios";
import {Web3} from "web3";


function MypageNFTcard({NFTitem,account,nftcontract}) {
    // console.log(NFTitem);
    const tokenId = NFTitem.tokenId;

    const buyNFT = async () =>{
        await payNFT();
        const nftBuyResult = await axios.post(`http://tvstorm-ai.asuscomm.com:12300/flower/market/buy?tokenid=${tokenId}`,{"account":account});
        console.log(nftBuyResult);

    }

    const payNFT = async ()=>{
        const payToNFT = await nftcontract.methods.buyToken(tokenId).send({
            from:account,
            value:2
        });
        console.log(payToNFT);

    }
    return (
    <div className="NFTcard" style={{
        width:"200px",
        height:"300px",
        backgroundColor:"white",
        borderRadius:"10px",
        margin:"0.5rem"
        }}>

        <Box sx={{
            color:"white"
        }}><Typography variant="h5" gutterBottom>
            {NFTitem.owner}
        </Typography></Box>
        <Box sx={{
            backgroundImage:`url(${ExampleImg})`,
            width:"170px",
            height:"100px",
            backgroundRepeat:"no-repeat",
            backgroundSize:"contain",
        }}/>
        <Box sx={{
            color:"black"
        }}><Typography variant="body2" gutterBottom>{NFTitem.description}</Typography></Box>

        <Box sx={{
        }}><Button variant="contained" color="success"  onClick={buyNFT}>
        SELL
      </Button></Box>

        </div>
  );
}

export default MypageNFTcard;
