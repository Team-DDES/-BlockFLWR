import {useEffect, useState} from "react";
import {Typography,Box,Button} from "@mui/material";
import ExampleImg from "../images/example_org_1.png"
import axios from "axios";
import {Web3} from "web3";


function NFTdetail({NFTitem,account,nftcontract}) {
    // console.log(NFTitem);
    const tokenId = NFTitem.tokenId;

    const sellNFT = async () =>{
        try{
            const approveNFT = await nftcontract.methods.approve("0xe86C29E9433C44e92bb35F00A2c9910c34d0f628",tokenId).send({
                from: account
            });
            console.log(approveNFT)
            const registerNFTtoMarket = await axios.post(`http://tvstorm-ai.asuscomm.com:12300/flower/market/register?tokenid=${tokenId}`,{
                "user_account":account,
                "price":2
            })
            console.log(registerNFTtoMarket)
        }catch(e){
            window.alert(e);
        }

    }
    return (
    <div className="NFTdetail" style={{
        width:"200px",
        height:"300px",
        backgroundColor:`rgba(255, 255, 255, 0.7)`,
        borderRadius:"10px",
        margin:"0.5rem",
        display:"flex",
        flexDirection:"column",
        alignItems:"center",

        }}>

        <Box sx={{
            color:"Black"
        }}><Typography variant="h6" gutterBottom>
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
            color:"black",
            marginLeft:"0.5rem",
            align:"center"

        }}><Typography variant="body2" gutterBottom>{NFTitem.description}</Typography></Box>

        <Box sx={{
        }}>
            <Button variant="contained" color="success"  onClick={sellNFT}>
            SELL
          </Button></Box>

        </div>
  );
}

export default NFTdetail;
