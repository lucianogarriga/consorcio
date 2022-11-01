// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BaseUser{

    string private name;
    address private withdrawAddress; 
    
    event EtherReceived(uint amount, address tenantAddress, uint balance);
    event WithdrawalSuccess (bool success, uint addressBalance);

    //cuando no haya data extra, ademas del value
    receive() external payable{ 
        emit EtherReceived(msg.value, address(this), address(this).balance);
    }
    //cuando si haya data extra
    fallback() external payable{
        emit EtherReceived(msg.value, address(this), address(this).balance);
     }

    constructor (string memory _name, address _withdrawAddress)   {
        name = _name;
        withdrawAddress = _withdrawAddress;
    }
    // realizar transferencia hacia withdrawAddress
    function withdrawal (uint _amount) public {
        //valida si el balance del contrato es >= al valor del servicio
        require(address(this).balance >= _amount, "Fondos insuficientes");
        // un bool si es true, realiza la transferencia al address que indicamos
        (bool success,) = withdrawAddress.call{
            value: _amount
        }("");
        //require(success == true, "Fallo la transferencia") - otra opcion;
        emit WithdrawalSuccess(success, address(this).balance);
    } 
    function getAddress() public view returns(address){
        return address(this);
    } 
    function showUserBalance() public view returns (uint) {
        return address(this).balance;
    }
}