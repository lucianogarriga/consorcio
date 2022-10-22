//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Servicios is Ownable{

    // la direccion del contrato Servicios puede recibir ETH y es publica
    address payable public servicesContract;
    // un mapa para servicios/empleados y fondos que recibiran
    mapping(string => uint) private services;

    event createdServices(
        string serv,
        uint balance
    );
    event etherServReceived(uint value);

    // funcion payable para recibir ethers en el contrato de servicios
    function depositServ() public payable {
        emit etherServReceived(msg.value);
    }
    // ver el balance del contrato de Servicios
    function getServBalance() public view returns(uint){
        return address(this).balance;
    }
    // ver el address del contrato de Servicios
    function getServAddres() public view returns(address){
        return address(this);
    } 
    // Solo el admin es quien puede agregar servicios 
    function addServices(string memory _serviceName, uint _value) public onlyOwner {
        require(services[_serviceName] == 0, "El servicio ya ha sido agregado"); 
        services[_serviceName] = _value;
        emit createdServices(_serviceName,_value);
    } 
}