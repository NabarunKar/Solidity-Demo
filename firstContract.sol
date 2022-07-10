pragma solidity ^0.8.4;

contract CryptoToken {
    //integer variables
    uint private totalSupply = 7;

    //addresses
    address public sender;
    address public minter;

    //constructor
    constructor() {
        minter = msg.sender; //assigns the value of the minter variable using in built solidity functionality
    }

    //mapping
    mapping(address => uint) public balances;

    //event
    event Sent(address from, address to, uint amount);

    //Functions:
    
    //1. mint
    function mint(address receiver, uint amount) public {
        //require
        require(msg.sender==minter); // a safety mechanism, no one can run the minter except msg.sender
        balances[receiver] += amount; // updating our balances map with key value pair
    }

    //2.send
    function send(address receiver, uint amount) public {
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }

    
}
