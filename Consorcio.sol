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
    event servicePaid(string serviceName, uint servicePrice);
    event salariesPaid();
    event serviceCreated(string serviceName);
    event servicesPaidSuccessfully();

    Employee[] private employeeList;
    Tenant[] private tenantList;
    Service[] private serviceList;

    Employee private aEmployee;
    Tenant private aTenant;

    // En esta var se acumula el precio total de los servicios que se debe pagar
    uint private servicePricesAcum;

    // para chequear que se recibe $ de un tenant, se define en estos 2
    receive() external payable { }
    fallback() external payable { }

    constructor() payable { 
    } 

    //Modifier p/ reutilizar codigo y verificar el balance sea suficiente
    modifier isEnoughbalance (uint _amount) {
        require(address(this).balance >= _amount, "Fondos insuficientes");
        _;
    }

    function showAddress() public view returns (address){
        return address(this);
    }

    //por cada empleado, se realiza una transferencia
    function paySalaries() public onlyOwner isEnoughbalance(getTotalSalaries()){
        for (uint i; i < employeeList.length; i++){
            transferToAddress(address(employeeList[i]), employeeList[i].getSalary());
        }
        emit salariesPaid();
    }

    function getTotalSalaries() private view returns(uint) {
        uint totalSalaries = 0;
        for (uint i; i > employeeList.length; i ++){
            totalSalaries += employeeList[i].getSalary();
        }
        return totalSalaries;
    }

    function transferToAddress(address toAddress, uint amount) public {
        (bool sent,) = toAddress.call{
            value: amount
        }("");
        require(sent == true, "Fallo la transferencia");
    }

    function payAllServices() public onlyOwner isEnoughbalance(servicePricesAcum){
        transferToAddress(getRandomAddress(), servicePricesAcum);
        emit servicesPaidSuccessfully();
    }

    function payService(uint index) public onlyOwner isEnoughbalance(serviceList[index].price){
        transferToAddress(getRandomAddress(), serviceList[index].price);
        emit servicePaid(serviceList[index].name, serviceList[index].price);
    } 
    
    // funcion para crear un nuevo servicio y agregarlo al Service []
    function addNewService(string memory serviceName, uint servicePrice) public onlyOwner {
            // Service al no ser un contrato, no se debe indicar con new Service
        //serviceList.push(Service(serviceName, servicePrice));
        Service memory service = Service(serviceName, servicePrice);
        serviceList.push(service);
        servicePricesAcum += servicePrice;
        emit serviceCreated(serviceName);
    }

    function getRandomAddress() private pure returns (address){
        return 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
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
    string memory _profession, string memory _schedule, uint salary) 
    public onlyOwner{ 
        employeeList.push(new Employee(_name, _withdrawAddress, _profession, 
        _schedule, salary));
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