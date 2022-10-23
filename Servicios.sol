//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Servicios is Ownable{

    // un mapa para servicios/empleados y fondos que recibiran
    mapping(string => uint) private services;

    event createdServices(
        string serv,
        uint balance
    );

    receive() external payable {}
    fallback() external payable {}
    constructor(){}

    // ver el balance del contrato de Servicios
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    // Solo el admin es quien puede agregar servicios 
    function addServices(string memory _serviceName, uint _value) public onlyOwner {
        require(services[_serviceName] == 0, "El servicio ya ha sido agregado"); 
        services[_serviceName] = _value;
        emit createdServices(_serviceName,_value);
    } 
}