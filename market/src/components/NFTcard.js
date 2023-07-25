import {useEffect, useState} from "react";
import {Typography,Box,Button} from "@mui/material";
import ExampleImg from "../images/example_org_1.png"
function NFTcard({NFTitem,account}) {
    console.log(NFTitem);

    return (

    <div className="NFTcard" style={{
        width:"200px",
        height:"300px",
        backgroundColor:"black",
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
            // backgroundAttachment:"fixed"
        }}/>
        <Box sx={{
            color:"white"
        }}><Typography variant="body2" gutterBottom>{NFTitem.description}</Typography></Box>

        <Box sx={{
        }}><Button variant="contained" color="success">
        BUY
      </Button></Box>

        </div>
  );
}

export default NFTcard;
