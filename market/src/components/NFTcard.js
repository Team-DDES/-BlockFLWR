import {useEffect, useState} from "react";
import {useNavigate} from "react-router-dom";
import {Typography,Box,Button} from "@mui/material";
import ExampleImg from "../images/example_org_1.png"
import axios from "axios";
import {Web3} from "web3";
import mypageNFTcard from "./MypageNFTcard";


function NFTcard({NFTitem,account,nftcontract}) {
    // console.log(NFTitem);
    const tokenId = NFTitem.tokenId;
    console.log(account)
    const navigate = useNavigate();

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

    const moveTodetail = () =>{
        navigate(`/detail/${tokenId}/${account}`);
    }
    return (
    <div className="NFTcard" style={{
        width:"200px",
        height:"300px",
        backgroundColor:"black",
        borderRadius:"10px",
        margin:"0.5rem",
        display:"flex",
        flexDirection:"column",
        alignItems:"center",
        }}

    >

        <Box sx={{
            color:"white"
        }}><Typography variant="h5" gutterBottom>
            {NFTitem.owner}
        </Typography></Box>
        <Box
            sx={{
            backgroundImage:`url(${ExampleImg})`,
            width:"170px",
            height:"70px",
            backgroundRepeat:"no-repeat",
            backgroundSize:"100% 100%",

        }}/>
        <Box sx={{
            color:"white",
            margin:"1rem"
        }}><Typography variant="body2" gutterBottom oncClick={moveTodetail} >{NFTitem.description}</Typography></Box>

        <Box sx={{
        }}><Button variant="contained" color="success"  onClick={buyNFT}>
        BUY
      </Button>
       <Button variant="outlined"  onClick={moveTodetail}>
        Detail
      </Button>
        </Box>

        </div>
  );
}

export default NFTcard;
