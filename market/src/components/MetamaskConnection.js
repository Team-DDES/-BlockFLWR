import {useEffect, useState} from "react";
import {Web3} from "web3";
import greenLight from "../images/common_lightgreen_btn_00FF0A.png"
import redLight from "../images/main_wallet_notconnect.png"

function MetamaskConnection({connected}) {
    // const [accounts, setAccounts] = useState([]);
    return(

       <div calssName="matamaskConnection">
           <p>wallet connection</p>
           {connected?(
               <div style={{
               backgroundRepeat:"no-repeat",
               backgroundImage:`url(${greenLight})`,
                   backgroundSize:"100% 100%",
                   width:"20px",
                   height:"20px"
           }}/>
           ):(
                <div style={{
               backgroundRepeat:"no-repeat",
               backgroundImage:`url(${redLight})`, backgroundSize:"100% 100%",
                   width:"20px",
                   height:"20px"
           }}/>
           )}
           </div>
  );
}

export default MetamaskConnection;
