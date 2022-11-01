// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./BaseUser.sol";

contract Employee is BaseUser {

    // declaramos var globales de estado, y los modificadores inician con _
    string private profession;
    string private schedule;

    constructor (
        string memory _name,
        address _withdrawAddress,
        string memory _profession,
        string memory _schedule
    ) // para llamar al padre => llamarlo luego de los parametros del constructor
    BaseUser (_name, _withdrawAddress) {
        profession = _profession;
        schedule = _schedule;
    }
}