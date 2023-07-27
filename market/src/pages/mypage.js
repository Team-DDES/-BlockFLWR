import {useEffect, useState} from "react";
import {useParams, useNavigate} from "react-router-dom";
import {Button,Box,Typography} from "@mui/material";
import BGimg from "../images/marketplace_background.png"
import Title from "../images/marketplace_title.png"
import Exit from "../images/common_exit.png"
import Profile from "../images/mypageIcon.png"
import axios from "axios";
import MypageNFTcard from "../components/MypageNFTcard";
import {Web3} from "web3";
import nft_abi from "../web3/nft_abi";


function Mypage() {
  const {account} = useParams();
  const navigate = useNavigate();
  const [items,setItems] = useState([]);
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

  useEffect(async ()=>{
        // console.log(await getMyItemList())
        const marketNFTs = await getMyItemList();

        setItems(marketNFTs.data);
        const _web3 = await initWeb3();
        setWeb3(_web3);
        const _nftContract = await initContract(_web3, nft_abi.nft_abi, nftContractAddress);
        setNftcontract(_nftContract);
    },[])

    const getMyItemList = async() =>{
        return await axios.get(`http://tvstorm-ai.asuscomm.com:12300/flower/market/my?account=${account}`);
    }

  const handleExit = () =>{
      navigate(-1);
  }

  return (
    <div className="Mypage" style={{
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
        width:"80vw",
        height:"75vh",
        borderRadius:"20px",
          display:"flex",
          flexDirection:"column"

      }} className="myPageBlackBox">
          <Box className ="Title" sx = {{
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
          <Box className={"profileAndWelcome"} sx = {{
              display:"flex",
              justifyContent:"left",
              marginLeft:"1rem",
              alignItems:"center"

          }}>
            <div className="profileImg" style={{
                backgroundImage:`url(${Profile})`,
                backgroundRepeat:"no-repeat",
                backgroundSize:"contain",
                width:"100px",
                height:"100px"
            }}/>
            <Box sx ={{
                display:"flex",
                flexDirection:"column",
                width:"300px",
                height:"50px",
                color:"white",
                margin:"2rem",

            }} className="Welcome">
                <Typography variant={"h5"}>Hi,</Typography>
                <Typography variant={"h5"}>{account}</Typography>
            </Box>
          </Box>
          <Box className="collections" sx={{
                  color:"white",
                    display:"flex",
              flexDirection:"column",
              marginLeft:"2.5rem",
              marginRight:"2.5rem",
              marginTop:"1rem",
                alignItems:"center"
              }}>
                 <Typography variant={"h5"}>Your Collections</Typography>
                  <Box className="collectionListBox" sx={{
                      witdh:"60vw",
                      height:"40vh",
                  }}>
                  {items.length > 0 ? (
                      items.map((item) => (
                       <MypageNFTcard NFTitem={item} account={account} nftcontract={nftcontract}/>
                      ))
                    ) : (
                      <div>NO NFT here :(</div>

                    )}
                  </Box>
              </Box>
      </Box>
    </div>
  );
}

export default Mypage;