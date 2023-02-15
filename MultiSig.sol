// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract MultiSig{

    event Deposit(address indexed _sender, uint _amount, uint _date);
    event Withdrawn(address indexed _sender, uint _amount, uint _date);   

    ///@notice This smart contract is currently not fully functioning.
    
    /*
        Be cautious if you want to use this example in real world.
        It is recomeded to double check smart contract for potential bugs and vulnerabilites
        manually, and using automatic & testing tools (e.g. Slither, Truffle)
    */

    struct Transfer{
        address sender;
        address receiver;
        uint amount;
        uint approve;
        uint date;
    }

    Transfer[] transfer;

    address owner;
    address[] public walletOwners;
    mapping(address => uint) balance;

    constructor(){
        owner = msg.sender;
        walletOwners.push(owner);
    }

    modifier onlyOwner(){
        
        bool isOwner = false;

        // loop through array to check if msg.sender is not an owner
        for(uint i = 0; i < walletOwners.length; i++){
            if(walletOwners[i] == msg.sender){
                isOwner = true;
                break;
            }
        }

        // if isOwner is true = allow to execute
        require(isOwner == true, "existing owner");
        _;
    }

    /*
        adding a new owner to the wallet
        we use require() to make sure that only existing owner can add a new owner
        also this function saves from duplicate owners
    */
    function addWalletOwner(address _owner) public onlyOwner {
        
        // check if owner is already exist
        for(uint i = 0; i < walletOwners.length; i++){
            if(walletOwners[i] == _owner){
                revert("duplicate");
            }
        }

        // if all requirements passed = add new owner
        walletOwners.push(_owner);
    }

    function removeWalletOwner(address _owner) public onlyOwner {
        bool alreadyExist = false;
        uint walletIndex;
        
        // loop through entire array
        for(uint i = 0; i < walletOwners.length; i++){
            alreadyExist = true;

            // check if owner has been found
            if(walletOwners[i] == _owner){
                alreadyExist = true;
                walletIndex = i;
                break;
            }
        }
        require(alreadyExist == true, "owner not detected");

        /*
            actual removing an owner
            if owner under specific index was found = move it to the last index of this array
            then remove it
        */
        walletOwners[walletIndex] = walletOwners[walletOwners.length - 1];
        walletOwners.pop();
    }

    /*
        deposit money with 'payable'
        mapping added to make sure deposit amount > 0
    */
    function deposit() public payable onlyOwner {
        
        // require deposit sum is greater than 0
        require(msg.value > 0, "deposit amount is too little");
        
        // assign ether value to the address
        balance[msg.sender] = msg.value;

        // log transaction when someone deposit money
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    // read-only getter function for specific balance
    function getBalance() public view returns(uint){
        return balance[msg.sender];
    }

    function withdrawn(uint _amount) public onlyOwner{
        
        // require that 
        require(balance[msg.sender] >= _amount);

        // remove _amount from msg.sender
        balance[msg.sender] -= _amount;

        // transfer funds
        payable(msg.sender).transfer(_amount);

        // log transaction when someone withdrawn money
        emit Withdrawn(msg.sender, _amount, block.timestamp);
    }

    // returns the balance of the entire contract
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }

    function makeTransfer(address _receiver, uint _amount) public onlyOwner{
        
        // security features
        require(balance[msg.sender] >= _amount, "insufficient funds");
        require(msg.sender != _receiver, "transfering to yourself is not allowed");

        // deducting _amount from balace of message sender
        balance[msg.sender] -= _amount;
        
        // adding transfer to a struct
        transfer.push(Transfer(msg.sender, _receiver, _amount, 0, block.timestamp));
    }
}
