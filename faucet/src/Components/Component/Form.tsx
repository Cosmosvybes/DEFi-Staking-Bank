import { Button, Col, FormGroup, Input } from "reactstrap";
import { MoneyBagCoins, RotateLock } from "react-huge-icons/bulk";
import { useAccount } from "wagmi";
import { toast } from "react-toastify";
import useContractMethods from "../Home/controller";
const Form = () => {
  const { isConnected, address } = useAccount();
  const { balanceOf, _mintToken } = useContractMethods();
  return (
    <FormGroup className=" w-full px-3">
      <Col className="flex justify-between flex-col gap-2 max-sm:gap-1">
        <p className="text-gray-50 font-semibold text-sm max-sm:text-xs text-center  max-sm:text-gray-100">
          Wallet address here
        </p>
        <Input
          value={isConnected ? address : ""}
          disabled
          placeholder={
            isConnected ? address : "connect your wallet 0x00000...."
          }
          className="w-full px-3 py-5 text-center rounded-sm max-sm:py-3 max-sm:w-full "
        />
        {isConnected && (
          <div className="relative flex justify-between gap-2">
            <Button
              onClick={() => _mintToken(address)}
              className="w-full px-3 py-3 flex justify-center gap-1 items-center hover:bg-black  transition duration-300 rounded-sm   font-semibold text-3xl max-sm:text-xl bg-black max-sm:bg-yellow-500 hover:text-yellow-500 text-white "
            >
              MINT <RotateLock className="inline transition duration-500" />
            </Button>
            <Button
              onClick={async (e) => {
                e.preventDefault();
                let _amount = await balanceOf(address);
                toast.success(
                  Number(_amount) > 0
                    ? ` ${_amount}  Mills token is available  🤑🤑`
                    : ` ${_amount}  Mills token is available🥺, mint token`
                );
              }}
              className="w-full px-3 py-3 flex justify-center gap-1 items-center hover:bg-black  transition duration-300 rounded-sm   font-semibold text-3xl max-sm:text-xl bg-black max-sm:bg-yellow-500 hover:text-yellow-500 text-white "
            >
              BALANCE{" "}
              <MoneyBagCoins className="inline transition duration-500" />
            </Button>
          </div>
        )}
      </Col>
    </FormGroup>
  );
};

export default Form;
