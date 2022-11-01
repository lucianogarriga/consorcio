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

    Employee private aEmployee;
    Tenant private aTenant;

    // para chequear que se recibe $ de un tenant, se define en estos 2
    receive() external payable {    }
    fallback() external payable {    }

    constructor() { 
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
    
    function addNewTenant() public onlyOwner {
        // la funcion crea una nueva instancia del Contrato Tenant
        aTenant = new Tenant("Luciano", 
        0xdD870fA1b7C4700F2BD7f44238821C26f7392148, 1000, "Ituzaingo", 
        address(this) );
    }
    //funcion para depositar al Tenant creado
    function depositTenant() public payable {
        (bool sent,) = aTenant.getAddress().call{
            // los fondos salen de la wallet que invoca la funcion
            value: msg.value
        }(""); 
        require (sent == true, "Tenant no pudo recibir fondos");
    }
    function tenantWithdrawal () public {
        aTenant.withdrawal(1000);
    }
    

    //funcion para depositar al Employee creado
    function addNewEmployee() public onlyOwner{ 
        //se crea una nueva instancia de Employee
        aEmployee = new Employee("Pedro", 
        0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, "Abogado", "De 6 a 15");
    }
    function depositEmployee() public payable{
        (bool sent,) = aEmployee.getAddress().call{
            value: msg.value
        }("");
        require(sent == true, "Employee no pudo recibir fondos");
    }

}