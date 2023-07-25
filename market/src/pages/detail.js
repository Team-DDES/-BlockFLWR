import React from "react";
import {useParams} from "react-router-dom";

function Detail({}) {
    const {tokenid} = useParams();
  return (
    <div className="Detail">
        {tokenid}
    </div>
  );
}

export default Detail;
