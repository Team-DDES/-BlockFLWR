// import React from "react";
import {useEffect, useState} from "react";
import {useParams,useNavigate} from "react-router-dom";
import axios from "axios";
import {Button,Box,Typography} from "@mui/material";
import BGimg from "../images/marketplace_background.png"
import Title from "../images/marketplace_title.png"
import Exit from "../images/common_exit.png"
import {Web3} from "web3";
import nft_abi from "../web3/nft_abi";

import sampleImg from "../images/example_org_1.png";
import deatilBg from "../images/popup_model_info_background.png";
import modelInfoAbs from "../images/Model info Abstract.png";
import buyBtn from "../images/common_lightgreen_btn_00FF0A.png";


function Detail() {
    const {tokenid, account} = useParams();
    const [nftInfo, setNftinfo] = useState({});
    const navigate = useNavigate();
    const [web3, setWeb3] = useState(null);
    const [nftcontract, setNftcontract] = useState(null);
    const nftContractAddress = "0x26358547718cA8c272C285a1d3161131570F480B";

    const initWeb3 = async () =>{
        try{
            const provider = window.ethereum;
            const web3 = new Web3(provider);
            return web3;

        }catch(e){
            console.log(`Error initializing web3:${e}`)
        }
    }

    const initContract = async (web3instance,contractABI, contractAddress)=>{
        const nftContract = new web3instance.eth.Contract(contractABI, contractAddress)
        return nftContract;
    }

     const buyNFT = async () =>{
        await payNFT();
        const nftBuyResult = await axios.post(`http://tvstorm-ai.asuscomm.com:12300/flower/market/buy?tokenid=${tokenid}`,{"account":account});
        console.log(nftBuyResult);
        navigate(-1);

    }

    const payNFT = async ()=>{
        const payToNFT = await nftcontract.methods.buyToken(tokenid).send({
            from:account,
            value:2
        });
        console.log(payToNFT);
    }


    const getNFTdetail = async () =>{
        const result = await axios.get(`http://tvstorm-ai.asuscomm.com:12300/flower/market/detail?tokenid=${tokenid}`);
        return result.data
    }
    const handleExit = () =>{
      navigate(-1);
  }

   useEffect(async ()=>{
        const detailInfo = await getNFTdetail();
        setNftinfo(detailInfo);
        const _web3 = await initWeb3();
        setWeb3(_web3);
        const _nftContract = await initContract(_web3, nft_abi.nft_abi, nftContractAddress);
        setNftcontract(_nftContract);
        // console.log(account)
    },[])

  return (
    <div className="Detail" style={{
        backgroundColor:"black",
        background:`url(${BGimg})`,
        backgroundRepeat:"no-repeat",
        backgroundSize:"100vw 100vh",
        width:"100vw",
        height:"100vh",
        display:"flex",
        flexDirection:"column",
        alignItems:"center"
    }}>
        <Box sx={{
            display:"flex",
            flexDirection:"row",
            width:"100vw",
            justifyContent:"space-between"
        }}>
          <div className="MarketTitle" style={{
              backgroundImage:`url(${Title})`,
              backgroundRepeat:"no-repeat",
              backgroundSize:"100%",
              width:"400px",
              height:"60px",
              margin:"20px"
          }}/>

            </Box>
        <Box sx={{
        backgroundColor:"black",
            backgroundImage:`url(${deatilBg})`,
            backgroundRepeat:"no-repeat",
            backgroundSize:"100% 100%",
        width:"80vw",
        height:"75vh",
        borderRadius:"20px",
          display:"flex",
          flexDirection:"column",

        }} className="deTailBlackBox">
            <Box className ="exitHeader" sx = {{
              display:"flex",
              justifyContent:"right"
          }}>
              <div style={{
                  backgroundImage:`url(${Exit})`,
                  backgroundRepeat:"no-repeat",
                  backgroundSize:"contain",
                  width:"25px",
                  height:"25px",
                  margin:"0.5rem"
              }} onClick={handleExit}/>
          </Box>
            <Box className="Title" sx={{
                color:"white",
                display:"flex",
                marginLeft :"2rem",
                marginRight:" 2rem",

            }}>
                <div style={{
                    width:"400px",
                    height:"150px",
                    backgroundImage:`url(${sampleImg})`,
                    backgroundSize:"100%",
                    margin:"0.2rem",
                    backgroundRepeat:"no-repeat"
                }}>

                </div>
                <Box className="OwnerAndDescription" sx={{
                    marginLeft:"1rem"
                }}>
                    <Typography variant={"h4"}> {nftInfo.owner}</Typography>
                    <Typography variant={"body1"}> {nftInfo.description}</Typography>
                </Box>
            </Box>
                <Box className ="ModelInfo" sx={{
                    display:"flex",
                    justifyContent:"center",
                    alignItems:"center",
                        width:"100%",
                        height:"100%",
                    }}>
                        <Box className = "TitleandInfo" sx={{
                            display:"flex",
                            flexDirection:"column",
                            width:"40%",
                            height:"100%",
                            alignItems:"center",
                            justifyContent:"center"
                        }}>
                            <div calssName ="ModelInfoAbs" style={{
                                backgroundImage:`url(${modelInfoAbs})`,
                                backgroundRepeat:"no-repeat",
                                backgroundSize:"contain",
                                width:"300px",
                                height:"50px"
                            }}/>
                            <Box sx={{
                                display:"flex",
                                color:"white",
                                flexDirection:"column",
                                alignItems:"left",
                            }}>
                                <Typography variant={"body1"}>Framework : {nftInfo.task_framework}</Typography>
                                <Typography variant={"body1"}>Trainers : {nftInfo.task_max_trainer}</Typography>
                                <Typography variant={"body1"}>Purpose : {nftInfo.task_name}</Typography>
                                <Typography variant={"body1"}>DataType : {nftInfo.task_data_type}</Typography>

                                //TODO: price call



                            </Box>
                            <div style={{
                                color:"white",
                                marginTop:"1rem"

                            }}>
                                <Typography variant={"h5"}> Price : 2 wei</Typography>
                            </div>
                            <div style={{
                                    backgroundImage:`url(${buyBtn})`,
                                    backgroundRepeat:"no-repeat",
                                    backgroundSize:"100% 100%",
                                    width:"200px",
                                    height:"30px",
                                    textAlign:"center",
                                margin:"2rem"
                                }}
                                onClick={buyNFT}
                            >Buy</div>
                        </Box>
                    </Box>
        </Box>

    </div>
  );
}

export default Detail;
