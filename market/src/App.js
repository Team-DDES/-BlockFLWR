import {BrowserRouter, Routes, Route} from "react-router-dom";
import Market from "./pages/market";
import Detail from "./pages/detail";
import Mypage from "./pages/mypage";

function App() {
  return (
    <div className="App">
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Market/>}></Route>
                <Route path="/detail/:tokenid" element={<Detail/>}></Route>
                <Route path="/mypage/:account" element={<Mypage/>}></Route>
            </Routes>
        </BrowserRouter>
    </div>
  );
};

export default App;
