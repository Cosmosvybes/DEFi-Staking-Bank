import { LinkUnlink } from "react-huge-icons/bulk";
import image from "../../assets/pexels-tima-miroshnichenko-7567556.jpg";
import Button from "../Component/Button";
import Form from "../Component/Form";
import useContractMethods from "./controller";

const Landing = () => {
  const { supply_value } = useContractMethods();

  return (
    <>
      <div className="relative h-screen  flex justify-between max-md:h-screen max-md:flex-col max-sm:h-screen">
        <div
          style={{ backgroundImage: `url(${image})` }}
          className="relative w-1/2 max-md:w-full max-md:h-screen max-md:flex-col  max-sm:w-full  max-sm:flex-col  max-sm:h-screen flex justify-center items-center bg-slate-300 max-sm:bg-black  h-full max-sm:bg-no-repeat max-sm:bg-contain object-contain bg-no-repeat bg-cover"
        >
          <div className="relative  flex justify-start max-sm:justify-center items-baseline  h-30  max-sm:h-72  w-72 max-sm:w-full max-sm:px-12 px-10 py-5 ">
            <Button />
          </div>

          <div className="relative h-full w-full  justify-center flex-col items-center px-0 hidden max-sm:flex  py-5">
            <h1 className="text-xl  font-extrabold text-gray-100 text-center">
              GET
              <span className="text-yellow-500 "> MILLS TOKEN </span> DELIVERED
              STRAIGHT TO YOUR WALLET.
            </h1>

            <h1 className="text-sm font-extrabold text-gray-100 mr-5 text-center">
              <LinkUnlink className="inline text-3xl text-yellow-500" />{" "}
              <span className="text-yellow-500 text-center ">
                {" "}
                Total Supply Volume :{" "}
              </span>
              {String(supply_value)}
            </h1>

            <Form />
          </div>

          <div className="absolute bottom-4 left-0 flex justify-center flex-col items-center py-10 px-2  rounded-md  h-auto  w-full">
            <h1 className="text-3xl max-sm:text-2xl font-semibold text-gray-100 mr-5">
              {" "}
              <span className="text-yellow-500 ">MILLS</span> TOKEN FAUCET.
            </h1>

            <p className="text-yellow-500 text-sm  right-3 absolute bottom-0">
              Multi-purpose utility asset!
            </p>
          </div>
        </div>

        <div className="relative h-full border-yello-500 max-md:w-full max-md:h-auto  max-sm:w-full  gap-10 flex-col max-sm:hidden px-10 flex justify-center  items-center bg-yellow-500 w-1/2">
          <h1 className="text-5xl font-extrabold text-gray-100 mr-5 text-center">
            GET
            <span className="text-black "> MILLS TOKEN </span> DELIVERED
            STRAIGHT TO YOUR WALLET.
          </h1>

          <h1 className="text-3xl font-extrabold text-gray-100 mr-5 text-center">
            <LinkUnlink className="inline text-5xl text-black" />{" "}
            <span className="text-black  "> Total Supply Volume : </span>{" "}
            {String(supply_value)}
          </h1>

          <div className="relative h-96 w-full  px-24 py-5">
            <Form />
          </div>
          <p className="text-2xl">
            The amount of Mills you’ll get is determined by daily request for
            fair distribution.
          </p>
        </div>
      </div>
    </>
  );
};

export default Landing;
