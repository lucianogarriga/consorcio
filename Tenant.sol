// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseUser.sol";

contract Tenant is BaseUser {

    uint private servicePrice;
    string private buildingAddress;
    address private consorcioAddress;

    event ExpensesPaid(uint pricePaid);
    event EtherReceived(uint amount);

    receive () external payable {}
    fallback () external payable {}

    constructor(
        string memory name, 
        address newWithdrawAddress,
        uint price,
        string memory newBuildingAdd, 
        address newConsorcioAdd
    ) payable BaseUser(name, newWithdrawAddress) {
        servicePrice = price;
        buildingAddress = newBuildingAdd;
        consorcioAddress = newConsorcioAdd;
    }
    // al ser payable el constructor y deposit(), el contrato puede recibir ETH
    function deposit() public payable{
        emit EtherReceived(msg.value);
    }

    function payExpenses() public{
        // no va a recibir ETH
        // requerir que el balance de esta address tenga + que el $ del servicio
        require(address(this).balance >= servicePrice, "Fondos insuficientes");
        (bool sent,) = consorcioAddress.call {
            value: servicePrice
        }("");

        require(sent == true, "Fallo la transferencia");
        emit ExpensesPaid(servicePrice);
    }

}