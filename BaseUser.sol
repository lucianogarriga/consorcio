// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BaseUser{

    string private name;
    address private withdrawAddress;
    uint private price;

    constructor (string memory _name, address _withdrawAddress)   {
        name = _name;
        withdrawAddress = _withdrawAddress;
    }

    function withdrawl () public {
        // TODO: realizar transferencia hacia withdrawAddress
        //valida si el balance del contrato es > al valor del servicio
        require(address(this).balance >= price, "Fondos insuficientes");
        // un bool si es true, realiza la transferencia al address que indicamos
        (bool sent,) = withdrawAddress.call{
            value: price
        }("");
        require(sent == true, "Fallo la transferencia");
    }
}