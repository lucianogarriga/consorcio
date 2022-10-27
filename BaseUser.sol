// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BaseUser{

    string private name;
    address private withdrawAddress;

    constructor (string memory _name, address _withdrawAddress)   {
        name = _name;
        withdrawAddress = _withdrawAddress;
    }

    function withdrawl () public {
        // TODO: realizar transferencia hacia withdrawAddress
    }
}