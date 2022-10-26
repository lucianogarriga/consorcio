// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Employee.sol";
import "./Tenant.sol";

contract Consorcio is Ownable{

    struct Service{
        string name;
        uint price;
    }
    
    Employee [] private employeeList;
    Tenant [] private tenants;
    Service [] private serviceList;

    mapping(address => Payer) private _payers;

    receive () external payable {}
    // para chequear que se recibe $ de un tenant, se define en estos 2
    fallback () external payable {}

    constructor () payable {

    }

    function paySalaries () public {}

    function payAllServices () public { }

    function payService(uint index) public {}

    function showAddress() public view returns (address){
        return address(this);
    }

    function addNewTenant() public {}

    function addNewEmployee() public {}

    function addNewService() public {}
}