// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// se importa el contrato Ownable de la libreria de openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Usuarios.sol";
import "./Servicios.sol";

contract Consorcio is Ownable, Servicios, Usuarios {
    // la direccion del admin puede recibir ETH y es publica
    address payable public admin;
    // un mapa para que arroje los balances de las address
    mapping (address => uint) private balances;

    constructor(){
        admin = payable(msg.sender); 
    }

    // evento para determinar las direcciones y valores de las transferencias
    event Transfer(
        address indexed from, 
        address indexed to, 
        uint value);
  
    event etherConsReceived(uint value);

    // es buena practica definir una funcion deposit y recibir ETH
    function depositConst() public payable {
        emit etherConsReceived(msg.value);
    }
    // ver el balance del contrato, no del admin
    function getConsBalance() public view returns(uint){
        return address(this).balance;
    }
    // ver el balance del admin
    function getAdminBalance() public view returns(uint){
        return admin.balance;
    }
    // ver el address del contrato
    function getContractAddres() public view returns(address){
        return address(this);
    } 

}