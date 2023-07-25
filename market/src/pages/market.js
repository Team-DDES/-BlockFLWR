import {useState,useEffect} from "react";
import axios from "axios";
import {Web3} from "web3";
import BGimg from "../images/marketplace_background.png"
import Title from "../images/marketplace_title.png"
import Search from "../components/Search"
import MetamaskConnection from "../components/MetamaskConnection";
import NFTcard from "../components/NFTcard";


function Market() {
    const [items,setItems] = useState([]);
    const [connected, setConnected] = useState(false);
    const [account, setAccount] = useState([]);
     useEffect(()=>{
        checkMetamaskConnection();
    },[]);

    const checkMetamaskConnection = async ()=>{
        if(window.ethereum){
            try{
                await window.ethereum.enable();
                setConnected(true);
                const web3 = new Web3(window.ethereum);
                const accounts = await web3.eth.getAccounts();
                console.log(accounts)
                setAccount(accounts[0]);
            }
            catch(e){
                console.error('Error connecting to Metamask:', e);

            }
        }else{
            console.warn('Metamask not found. Please install Metamask.');
        }
    }
    useEffect(async ()=>{
        console.log(await getMarketItemList())
        const marketNFTs = await getMarketItemList();
        setItems(marketNFTs.data);
    },[])

    const getMarketItemList = async ()=>{
        return await axios.get("http://tvstorm-ai.asuscomm.com:12300/flower/market/");
    }
  return (
    <div className="Market" style={{
        backgroundColor:"black",
        background:`url(${BGimg})`,
        backgroundRepeat:"no-repeat",
        backgroundSize:"100vw 100vh",
        width:"100vw",
        height:"100vh",
    }}>
      <div className="MarketTitle" style={{
          backgroundImage:`url(${Title})`,
          backgroundRepeat:"no-repeat",
          backgroundSize:"100%",
          width:"400px",
          height:"100px",
      }}/>
        <div className = "walletConnection" style={{
            backgroundColor: 'rgba(255, 255, 255, 0.5)',
            width:"200px",
            borderRadius:"10px"
        }}>
            <MetamaskConnection connected={connected}/>
        </div>

        <Search/>
       {items.length > 0 ? (
  items.map((item) => (
    <NFTcard  NFTitem={item} account={account}/>
  ))
) : (
  <div>No NFT list</div>
)}

    </div>
  );
}

export default Market;
