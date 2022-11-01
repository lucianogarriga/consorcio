// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./BaseUser.sol";

contract Employee is BaseUser {

    // declaramos var globales de estado, y los modificadores inician con _
    uint private immutable salary;
    string private profession;
    string private schedule;

    constructor (
        string memory _name,
        address _withdrawAddress,
        string memory _profession,
        string memory _schedule,
        uint _salary
    ) // para llamar al padre => llamarlo luego de los parametros del constructor
    BaseUser (_name, _withdrawAddress) {
        profession = _profession;
        schedule = _schedule;
        salary = _salary;
    }
    //Como salary ha sido declarada como private, 
    //se declara una funcion que obtiene a salary como parametro
    //y luego al ser publica se la puede llamar desde otro contrato
    function getSalary () public view returns(uint){
        return salary;
    }
}