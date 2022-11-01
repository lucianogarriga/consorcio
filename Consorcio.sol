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

    event servicesPaid(uint pricePaid); 

    Employee[] private employeeList;
    Tenant[] private tenantList;
    Service[] private serviceList;

    Employee private aEmployee;
    Tenant private aTenant;

    // para chequear que se recibe $ de un tenant, se define en estos 2
    receive() external payable { }
    fallback() external payable { }

    constructor() { 
    } 

    function showAddress() public view returns (address){
        return address(this);
    }

    function paySalaries() public {
        ///TODO(2): Una vez completado el TODO(1), implementar esta funcion. 
        ///Esta funcion deberia recorrer el array y calcular el total de salarios a pagar,
        ///validar que tenga fondos suficientes y si es suficiente, realizar el pago de todos los salarios.
    }

    function payAllServices(uint _serviceIndex, uint _amount) public {
        require(_serviceIndex < serviceList.length, "El servicio no existe");
        require(address(this).balance >= _amount, "Fondos insuficientes");
        (bool sent,) = address(0).call {
            value: _amount
        }("");
        require(sent == true, "Fallo la transferencia");
        emit servicesPaid(_amount);
    }

    function payService(uint index) public {}

    // funcion para crear un nuevo servicio y agregarlo al Service []
    function addNewService(string memory _serviceName, uint _servicePrice) public onlyOwner {
            // Service al no ser un contrato, no se debe indicar con new Service
        serviceList.push(Service(_serviceName, _servicePrice));
    }
    // funcion para crear un nuevo tenant con sus propiedades y agregarlo al tenantList
    function addNewTenant(string memory _name, address _withdrawAddress,
        uint _servicePrice, string memory _buildingAddress, 
        address _consorcioAddress) public onlyOwner { 
            // Tenant al ser un contrato se debe indicar con new Tenant
        tenantList.push(new Tenant(_name, _withdrawAddress, _servicePrice,
         _buildingAddress, _consorcioAddress));  
    }
    // funcion para saber la cantidad de tenant creados y guardados en tenantList
    function tenantArray() public view returns(uint){  
        uint tLenght = tenantList.length;
        return tLenght;  
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
    
    //funcion para crear un nuevo employee con sus propiedades y agregarlo al employeeList
    function addNewEmployee(string memory _name, address _withdrawAddress, 
    string memory _profession, string memory _schedule, uint _salary) 
    public onlyOwner{ 
        employeeList.push(new Employee(_name, _withdrawAddress, _profession, 
        _schedule, _salary));
    }
    //funcion para saber la cantidad de employee creados y guardados en employeeList
    function employeeArray() public view returns (uint) {
        uint eLength = employeeList.length;
        return eLength;
    }
    //funcion para depositar al Employee creado
    function depositEmployee() public payable{
        (bool sent,) = aEmployee.getAddress().call{
            value: msg.value
        }("");
        require(sent == true, "Employee no pudo recibir fondos");
    }

}