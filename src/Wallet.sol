// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract Wallet {
    address payable public owner;

    event Deposit(address from, uint256 amount);

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amout) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(amout);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "caller is not owner");
        owner = payable(_owner);
    }
}
