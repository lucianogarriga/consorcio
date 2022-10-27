// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Employee.sol";
import "./Tenant.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Consorcio is Ownable {

    address private ADMIN; 
    mapping(address=> Service) addressToService;

    struct Service {
        string name;
        uint price;
    }

    event servicePaid(uint pricePaid);

    Employee[] private employeeList;
    Tenant[] private tenantList;
    Service[] private serviceList;

    // para chequear que se recibe $ de un tenant, se define en estos 2
    receive () external payable {}
    fallback () external payable {}

    constructor () payable { 
    } 

    function showAddress() public view returns (address){
        return address(this);
    }

    function paySalaries() public {}

    function payAllServices() public {}

    function payService(uint _serviceIndex, uint _amount) public {
        require(_serviceIndex < serviceList.length, "El servicio no existe");
        require(address(this).balance >= _amount, "Fondos insuficientes");
        (bool sent,) = address(0).call {
            value: _amount
        }("");
        require(sent == true, "Fallo la transferencia");
        emit servicePaid(_amount);
    }

    function addNewService(string memory _serviceName, uint _servicePrice) public onlyOwner {
        serviceList.push(Service(_serviceName, _servicePrice));
    }
    
    function addNewTenant(Tenant _tenant) public onlyOwner {
        tenantList.push(_tenant);
    }

    function addNewEmployee(Employee _employee) public onlyOwner{
        employeeList.push(_employee);
    }

}