// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./BaseUser.sol";

contract Tenant is BaseUser {

    // declaramos var globales de estado, y los modificadores inician con _
    // debemos definir el valor de las expensas y el address del consorcio
    uint private servicePrice;
    string private buildingAddress;
    address private consorcioAddress;

    event ExpensesPaid(uint pricePaid);  

    //marcando ademas como payable el constructor y deposit(), este SC recibira ETH
    constructor (
        string memory _name,
        address _withdrawAddress,
        uint _servicePrice,
        string memory _buildingAddress,
        address _consorcioAddress
    ) payable BaseUser (_name, _withdrawAddress) {
        servicePrice = _servicePrice;
        buildingAddress = _buildingAddress;
        consorcioAddress = _consorcioAddress; 
    }

    function showConsAddress(address _consorcioAddress) public {
        consorcioAddress = _consorcioAddress;
    } 

    function deposit() public payable {
        emit EtherReceived(msg.value, address(this), address(this).balance);
    }

    //utiliza el valor de _servicePrice p/ comparar cuanto debe enviar al Consorcio
    //lo utilizamos para validar si tenant tiene el balance suficiente para pagarlo
    function payExpenses() public {
        //valida si el balance del contrato es >= al valor del servicio
        require(address(this).balance >= servicePrice, "Fondos insuficientes");
        // un bool si es true, realiza la transferencia al address que indicamos
        (bool sent,) = consorcioAddress.call{
            value: servicePrice
        }("");
        require(sent == true, "Fallo la transferencia");
        emit ExpensesPaid(servicePrice);
    } 
}