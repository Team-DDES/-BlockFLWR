import {TextField} from "@mui/material";
import {makeStyles} from "@mui/styles";
import {useEffect, useState} from "react";

function Search({}) {
    const useStyles = makeStyles(theme => ({
    Searchbar:{
        width:"80vw",
        height:"100%",
        backgroundColor:"white"
    }
}));
    // states
    const [search,setSearch] = useState("");
    const classes = useStyles();

    const handleChange = (e)=>{
        setSearch(e.target.value);
    }

    useEffect(()=>{
        console.log(search)
    },[search])
    return (

    <div className="Search" style={{
            width:"80vh"
        }}>
        <TextField className={classes.Searchbar} onChange={handleChange} id="outlined-search" label="Search field" type="search" />
        </div>
  );
}

export default Search;
