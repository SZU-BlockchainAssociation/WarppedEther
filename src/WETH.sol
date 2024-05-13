// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract WETH is ERC20 {

    error WETH__InsufficientBalance(uint256 balance, uint256 amountNeed);
    
    constructor() ERC20('Wrapped Ether', 'WETH') {}

    event Deposit(address indexed destination, uint256 value);
    event Withdrawal(address indexed source, uint256 value);

    fallback() external payable {
        deposit();
    }
    
    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        if(balanceOf(msg.sender) < amount) {
            revert WETH__InsufficientBalance(balanceOf(msg.sender), amount);
        }        
        payable(msg.sender).transfer(amount);
        _burn(msg.sender, amount);
        emit Withdrawal(msg.sender, amount);
    }
}
