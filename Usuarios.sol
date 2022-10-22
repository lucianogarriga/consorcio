//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Servicios.sol";

contract Usuarios is Ownable, Servicios{

    //Mapeo de usuarios (address) y tendran fondos (uint)
    //esta lista de usuarios son los que pagaran expensas y serv
    mapping(address => uint) private inquilinos; 
    mapping(address => uint) private propietarios; 

    event createdUsers(
        address user,
        uint balance
    );

    // ver el balance del contrato de Usuarios
    function getUsersBalance() public view returns(uint){
        return address(this).balance;
    }
    // ver el address del contrato de Usuarios
    function getUsersAddres() public view returns(address){
        return address(this);
    } 

    // Solo el admin es quien puede agregar usuarios 
    function addInq(address _userAddress, uint _balance) public onlyOwner {
    require(inquilinos[_userAddress] == 0, "El inquilino ya existe");
    inquilinos[_userAddress] = _balance;
    emit createdUsers(_userAddress,_balance);
    } 
    function addProp(address _userAddress, uint _balance) public onlyOwner {
    require(propietarios[_userAddress] == 0, "El propietario ya existe");
    propietarios[_userAddress] = _balance;
    emit createdUsers(_userAddress,_balance);
    } 
}