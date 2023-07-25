import {useEffect, useState} from "react";
import {useWeb3React} from "@web3-react/core";
import {Web3} from "web3";


function Metamask() {
    const [accounts, setAccounts] = useState([]);
    const [connected, setConnected] = useState(false);

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
                setAccounts(accounts);
            }
            catch(e){
                console.error('Error connecting to Metamask:', e);

            }
        }else{
            console.warn('Metamask not found. Please install Metamask.');
        }
    }

    return(

       <div calssName="matamask">
           {connected?(
               <div>
              Connected with metamask!
          </div>
           ):(<div>Please Connect to Metamask.</div>)}

        </div>
  );
}

export default Metamask;
