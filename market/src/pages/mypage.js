import {useParams} from "react-router-dom";

function Mypage() {
  const {account} = useParams();
  return (
    <div className="Mypage">
        {account}
    </div>
  );
}

export default Mypage;