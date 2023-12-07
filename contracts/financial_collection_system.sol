// SPDX-License-Identifier: MIT

// Nome: João Guilherme Lopes Alves da Costa
// Nome: Jonas de Oliveira Freire Filho
// Conta do contrato: <>

pragma solidity ^0.8.19;

contract FinancialCollectionSystem {
    event AccountCreated(
        string indexed uniqueIdentifier,
        string creatorInformation,
        uint256 timestamp
    );
    event DepositMade(
        string indexed uniqueIdentifier,
        address indexed depositor,
        uint256 deposit
    );
    event WithdrawalMade(
        string indexed uniqueIdentifier,
        address indexed withdrawer,
        uint256 amount
    );
    event ContractDestructed(address indexed manager, uint256 managerProfit);

    address private manager;
    uint256 private managerProfit;

    mapping(string => address) private identifierToCreator;
    mapping(string => Account) private accounts;

    struct Account {
        address creatorAddress;
        string uniqueIdentifier;
        string securityKey;
        string description;
        string creatorInformation;
        uint256 balance;
        uint256 expirationDate;
        uint256 minDeposit;
        uint256 maxDeposit;
        uint256 amountDeposited;
        bool earlyWithdrawal;
    }

    modifier restricted() {
        require(
            msg.sender == manager,
            "Only the manager can call this function"
        );
        _;
    }

    constructor() {
        manager = msg.sender;
    }

    function existsAccount(
        string memory uniqueIdentifier
    ) public view returns (bool) {
        return identifierToCreator[uniqueIdentifier] != address(0);
    }

    function getAccountInformation(
        string memory uniqueIdentifier
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            bool
        )
    {
        // Verificar se a conta associada ao identificador único existe
        require(
            identifierToCreator[uniqueIdentifier] != address(0),
            "Account does not exist"
        );

        // Obter a conta associada ao identificador único
        Account storage account = accounts[uniqueIdentifier];

        return (
            account.uniqueIdentifier,
            account.description,
            account.creatorInformation,
            account.balance,
            account.expirationDate,
            account.minDeposit,
            account.maxDeposit,
            account.amountDeposited,
            account.earlyWithdrawal
        );
    }

    function createAccount(
        string memory uniqueIdentifier,
        string memory securityKey,
        string memory description,
        string memory creatorInformation,
        bool earlyWithdrawal,
        uint256 expirationDate,
        uint256 minDeposit,
        uint256 maxDeposit
    ) public {
        // Verificar se o identificador único já existe
        require(
            identifierToCreator[uniqueIdentifier] == address(0),
            "This unique identifier is already in use"
        );

        // Verificar se a data de validade é válida
        require(expirationDate > block.timestamp, "Invalid expiration date");

        // Verificar se o valor mínimo de depósito é menor ou igual ao valor máximo de depósito
        require(minDeposit <= maxDeposit, "Invalid deposit range");

        // Criar uma nova conta
        Account memory newAccount = Account({
            creatorAddress: msg.sender,
            uniqueIdentifier: uniqueIdentifier,
            securityKey: securityKey,
            description: description,
            creatorInformation: creatorInformation,
            balance: 0,
            expirationDate: expirationDate,
            minDeposit: minDeposit,
            maxDeposit: maxDeposit,
            amountDeposited: 0,
            earlyWithdrawal: earlyWithdrawal
        });

        // Adicionar a nova conta ao mapeamento de contas
        accounts[uniqueIdentifier] = newAccount;

        // Adicionar o identificador único ao mapeamento de identificadores únicos
        identifierToCreator[uniqueIdentifier] = msg.sender;

        // Emitir evento ou registrar log
        emit AccountCreated(
            uniqueIdentifier,
            creatorInformation,
            block.timestamp
        );
    }

    function depositValue(string memory uniqueIdentifier) public payable {
        // Verificar se a conta associada ao identificador único existe
        require(
            identifierToCreator[uniqueIdentifier] != address(0),
            "Account does not exist"
        );

        // Obter a conta associada ao identificador único
        Account storage account = accounts[uniqueIdentifier];

        // Verificar se o depósito está dentro do intervalo permitido
        require(
            msg.value >= account.minDeposit && msg.value <= account.maxDeposit,
            "Invalid deposit amount"
        );

        // Calcular 1% do depósito para o managerProfit
        uint256 managerShare = (msg.value * 1) / 100;
        uint256 deposit = msg.value - managerShare;

        // Incrementar o saldo da conta
        account.balance += deposit;
        account.amountDeposited += deposit;

        // Incrementar o managerProfit
        managerProfit += managerShare;

        // Emitir evento ou registrar log
        emit DepositMade(uniqueIdentifier, msg.sender, deposit);
    }

    function withdrawValue(
        string memory uniqueIdentifier,
        string memory securityKey
    ) public {
        // Verificar se a conta associada ao identificador único existe
        require(
            identifierToCreator[uniqueIdentifier] != address(0),
            "Account does not exist"
        );

        // Obter a conta associada ao identificador único
        Account storage account = accounts[uniqueIdentifier];

        // Verificar se a chave de segurança está correta
        require(
            keccak256(abi.encodePacked(securityKey)) ==
                keccak256(abi.encodePacked(account.securityKey)),
            "Invalid security key"
        );

        if (!account.earlyWithdrawal) {
            // Verificar se a data de validade da conta já passou
            require(
                block.timestamp < account.expirationDate,
                "Early withdrawal is not allowed"
            );
        }

        // Verificar se o saldo da conta é maior que zero
        require(account.balance > 0, "Account balance is zero");

        // Transferir o saldo da conta para o endereço do criador da conta
        payable(account.creatorAddress).transfer(account.balance);

        // Emitir evento ou registrar log
        emit WithdrawalMade(uniqueIdentifier, msg.sender, account.balance);

        // Zerar o saldo da conta
        account.balance = 0;
    }

    // Função para sacar o lucro do manager e destruir o contrato
    function getManagerProfitAndDestructContract() public restricted {
        // Transfer any remaining funds in the contract to the manager
        if (managerProfit > 0) {
            payable(manager).transfer(managerProfit);
        }

        // Emit an event indicating the contract destruction
        emit ContractDestructed(manager, managerProfit);

        // Self-destruct the contract and transfer any remaining ether to the manager
        selfdestruct(payable(manager));
    }
}
