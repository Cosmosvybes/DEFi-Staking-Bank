import "./App.css";
import Landing from "./Components/Home/Landing";
import "react-toastify/ReactToastify.css";
import { ToastContainer } from "react-toastify";
import { Web3ModalProvider } from "./Components/Home/web3/Provider";
function App() {
  return (
    <>
      <ToastContainer />
      <Web3ModalProvider children={<Landing />} />
    </>
  );
}

export default App;
