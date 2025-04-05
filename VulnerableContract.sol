//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    //Users deposit Ether into the contract.
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    //Withdraw funds; vulnerable to reentrancy.
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient funds");
        //Transfer Ether to the caller.
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
        //Update the balance after transferring funds.
        balances[msg.sender] -= _amount;
    }
}
