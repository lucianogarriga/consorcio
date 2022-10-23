// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// se importa el contrato Ownable de la libreria de openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Usuarios.sol";
import "./Servicios.sol";

contract Consorcio is Ownable {
    // la direccion del admin puede recibir ETH y es publica
    address payable public admin;
    // tiene una instancia del contrato Servicios
    Servicios private servicios;
    // Se guarda el admin y se inicia la instancia del contracto Servicios
    constructor() payable {
        admin = payable(msg.sender); 
        // Tambien se hace un deploy del contrato Servicios
        servicios = new Servicios();
    }
    // evento que indica que se recibieron los ETH
    event EtherConsReceived(uint value);

    // es buena practica definir una funcion deposit y recibir ETH
    function depositCons() public payable {
        emit EtherConsReceived(msg.value);
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
    function getConsAddres() public view returns(address){
        return address(this);
    } 

    // RESPECTO DEL CONTRATO DE SERVICIOS
    // Ver el address del contrato Servicios
    function getServAddress() public view returns(address){
        return address(servicios); 
    }
    // Ver el balance del contrato Servicios
    function getServBalance() public view returns(uint){
        return servicios.getBalance();
    }

    // Funcion para transferir ETH al contrato Servicios
    function pay() public payable onlyOwner {
        require(address(this).balance >= 1000, "Este contrato no tiene suficientes ETH");
        (bool sent, bytes memory data) = getServAddress().call{
            value: 1000
        }("");
        require(sent, "Error al enviar ETH");
    }
}