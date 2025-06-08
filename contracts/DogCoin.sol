// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.28;

struct Payment {
        uint256 amount;
        address recipient;
    }

contract DogCoin {
    uint256 totalSupply = 2000000;
    address private owner;

    event SupplyUpdated(uint256 newTotal);
    event Transfer(address indexed to, uint256 value);

    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;


    constructor(address _initialOwner) {
        owner = _initialOwner;
        balances[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function getTotalSupply() public view onlyOwner returns(uint256) {
        return totalSupply;
    }

    function addTokens() public onlyOwner {
        totalSupply = totalSupply + 1000;
        emit SupplyUpdated(totalSupply);
        balances[owner] = totalSupply;
    }

    function transfer(address to, uint256 value) public onlyOwner returns (bool) {
         require(balances[owner] >= value, "Insufficient balance");
         
        balances[owner] -= value;
        balances[to] += value;

        emit Transfer(to, value);

        payments[owner].push(Payment({
            amount: value, 
            recipient: to
        }));

         return true;
    }
}