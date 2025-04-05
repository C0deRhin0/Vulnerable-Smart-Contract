# Vulnerable Bank & Reentrancy Attack Demo

## 🔍 Overview

This project demonstrates a **Reentrancy Attack** on an Ethereum smart contract. It includes:

- A vulnerable smart contract (`VulnerableContract.sol`) that allows deposits and withdrawals.
- An attacker contract (`Attacker.sol`) that exploits a **Reentrancy Vulnerability** in the withdrawal function.

This is an educational project designed to help developers understand and prevent one of the most common smart contract vulnerabilities.

---

## 🧠 What You’ll Learn

- How Reentrancy Attacks work in Solidity.
- Best practices to secure smart contracts against such attacks.
- Using Truffle (or Hardhat) and Ganache for smart contract development and testing.

---

## 📂 Project Structure

## 🔧 Setup & Installation

### Prerequisites

- [Node.js](https://nodejs.org/)
- [Truffle](https://trufflesuite.com/)
- [Ganache CLI or GUI](https://trufflesuite.com/ganache/)

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/C0deRhin0/Vulnerable-Smart-Contract.git
   cd Vulnerable-Smart-Contract
   ```
   
2. **Install dependencies:**
   ```bash
   npm install
   ```
   
3. **Start Ganache:**
   ```bash
   ganache-cli
   ```
   
4. **Compile and migrate contracts:**
   ```bash
   truffle compile
   truffle migrate --reset
   ```
   
## 🚀 Running the Attack Demo
1. **Start Truffle Console:**
   ```bash
   truffle console
   ```
   
2. **Get deployed instances:**
   ```bash
   let bank = await VulnerableContract.deployed();
   let attacker = await Attacker.deployed();
   ```
   
3. **Fund the attacker and initiate attack:**
   ```bash
   await attack.attack({ from: accounts[1], value: web3.utils.toWei("1", "ether") });
   ```
   
4. **Check balances before and after:**
   ```bash
   await web3.eth.getBalance(bank.address);
   await web3.eth.getBalance(attacker.address);
   ```
### You’ll observe that the attacker drains the vulnerable contract’s funds recursively.

## ⚠️ Vulnerable Code Explained
```bash
function withdraw(uint256 _amount) public {
require(balances[msg.sender] >= _amount, "Insufficient funds");
(bool success, ) = msg.sender.call{value: _amount}("");
require(success, "Transfer failed");
balances[msg.sender] -= _amount;}
```

## ❌ Problem:
- The contract sends funds before updating the balance, allowing the attacker’s fallback function to re-enter and call withdraw again before their balance is reduced.
  
## 🛡️ Fix (Mitigation):
```bash
function withdraw(uint256 _amount) public {
require(balances[msg.sender] >= _amount, "Insufficient funds");
balances[msg.sender] -= _amount; // ✅ Update first
(bool success, ) = msg.sender.call{value: _amount}("");
require(success, "Transfer failed");}
```
- ✅ Checks-Effects-Interactions Pattern prevents reentrancy!
  
## 📘 References
  
- Ethereum Smart Contract Best Practices
- SWC Registry – SWC-107: Reentrancy

## 📝 License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any inquiries or support, please contact:

- **Author**: C0deRhin0 
- **GitHub**: [C0deRhin0](https://github.com/C0deRhin0)
