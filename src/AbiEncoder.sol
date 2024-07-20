// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;
import "./Token.sol";

contract abiEncoder {
    address SWIFTTOKEN;
    constructor() {
        SWIFTTOKEN = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    }

    function encodeTransfer(
        address _address,
        uint256 _amount
    ) public pure returns (bytes memory data) {
        bytes memory data_ = abi.encodeCall(
            Token.transfer,
            (_address, _amount)
        );
        SWIFTTOKEN.call(data_);
    }
}
